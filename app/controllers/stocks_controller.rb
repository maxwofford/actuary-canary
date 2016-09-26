class StocksController < ApplicationController
  def update
    gid = params[:gid]

    start_time = Time.now

    if gid
      update_stock_by_gid gid
    else
      update_all_stocks
    end

    crawl_time = ((Time.now - start_time) * 1000).to_i
    update_count = Option.all.count

    response = {
      crawl_time: crawl_time,
      update_count: update_count
    }.to_json

    render status: 200, json: response
  end

  private

  def update_all_stocks
    Stock.all.each do |stock|
      update_stock_by_gid stock.gid
    end
  end

  def update_stock_by_gid gid
    gfinance = GoogleFinanceAdapter.new
    stock = Stock.find_by gid: gid
    share_price = gfinance.get_price_by_gid gid
    stock.update!(share_price: share_price)
  end
end
