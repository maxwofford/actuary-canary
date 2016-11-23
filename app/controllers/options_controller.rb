class OptionsController < ApplicationController
  def index
    @options = Option.order("annualized_return DESC").take(10)
    flash[:notice] = "No options in database!" unless @options.any?
  end

  def update
    symbol = params[:symbol]
    gid = params[:gid]
    gid ||= Stock.find_by(symbol: symbol).gid if symbol

    start_time = Time.now

    if gid
      update_option_by_gid gid
    else
      update_all_options
      update_count = Option.all.count
    end

    crawl_time = ((Time.now - start_time) * 1000).to_i

    response = {
      crawl_time: crawl_time,
      update_count: update_count
    }.to_json

    render status: 200, json: response
  end

  def create
    symbol = params[:symbol]
    gid = params[:gid]

    start_time = Time.now

    gfinance = GoogleFinanceAdapter.new
    gid ||= gfinance.get_gid_by_symbol(symbol) if symbol
    Stock.create!(symbol: symbol, gid: gid)

    crawl_time = ((Time.now - start_time) * 1000).to_i

    response = {
      crawl_time: crawl_time
    }.to_json

    render status: 200, json: response
  end

  private

  def update_option_by_gid gid
    gfinance = GoogleFinanceAdapter.new
    options = gfinance.get_puts_by_gid gid
    options.each do |option|
      # Google denotes puts that aren't on the market with a volume of '-'
      unless option[:vol] == '-'
        stock = Stock.find_by gid: gid
        volume = option[:vol].to_i
        ask = option[:a].to_f
        bid = option[:b].to_f
        strike = option[:strike].to_f
        expiration = Date.parse(option[:expiry])
        profit = bid * volume
        annualized_return = profit * (expiration - Date.today()).to_i / 360

        opt = Option.new do |p|
          p.stock = stock
          p.volume = volume
          p.ask = ask
          p.bid = bid
          p.strike = strike
          p.expiration = expiration
          p.annualized_return = annualized_return
          p.return = profit / volume
        end

        opt.save
      end
    end
  end

  def update_all_options
    Option.delete_all

    Stock.all.each{ |stock|
      update_option_by_stock stock.symbol
    }
  end
end
