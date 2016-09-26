class GoogleFinanceAdapter
  require "http"

  def get_puts_by_symbol symbol
    gid = get_gid_by_symbol symbol
    return nil unless gid # Skip if we can't get this GID
    put_options = get_puts_by_gid gid
    return nil unless put_options # Skip if we can't get the option
    put_options.each { |put_option|
      put_option[:symbol] = symbol # Add symbol to the option
    }
  end

  def get_puts_by_gid gid
    # Read all put options by expiration date
    put_options = []
    get_expiration_dates(gid).each{ |date|
      new_put_options = get_option_by_gid(gid, date[:d], date[:m], date[:y])[:puts]
      raise "Received a non-200 response from Google" if new_put_options == nil
      put_options.concat(new_put_options)
    }
    put_options
  rescue
    Rails.logger.error { "Encountered an error when trying to get_puts_by_gid"\
                         " of gid '#{gid}'." }
    nil
  end

  def get_price_by_symbol symbol
    gid = get_gid_by_symbol symbol
    get_price_by_gid gid
  end

  def get_price_by_gid gid
    option_info = get_option_by_gid(gid, 0, 0, 0)
    option_info[:underlying_price] if option_info
  end

  def get_gid_by_symbol symbol
    params = {
      q: symbol, # Symbol to query
      matchtype: :matchall,
      output: :json
    }

    uri = "#{BASE_URI}/match?#{params.to_query}"
    string_resp = Http.get(uri).body.to_s

    # This response from Google should be valgid JSON, so we can parse it now
    json = JSON.parse(string_resp, symbolize_names: true)

    # Return the gid of the first match if we get a non-empty response
    json[:matches].empty? ? nil : json[:matches].first[:id]
  rescue => e
    Rails.logger.error { "Encountered an error when trying to"\
                         " get_gid_by_symbol '#{symbol}'. #{e.message}"\
                         " #{e.backtrace.join("\n")}" }
    nil
  end

  private

  BASE_URI = "https://www.google.com/finance".freeze

  def get_expiration_dates gid
    # Google Finance's API returns a list of expiration dates when requesting a
    # non-valgid expiration date (I'm using 0/0/0)
    option = get_option_by_gid(gid, 0, 0, 0)[:expirations]
    return option if option
  end

  def get_option_by_gid(gid,
                        expiration_day=nil,
                        expiration_month=nil,
                        expiration_year=nil)

    # Required params
    params = {
      output: :json,
      cgid: gid # GID to query
    }

    # Optional params
    params[:expd] = expiration_day if expiration_day
    params[:expm] = expiration_month if expiration_month
    params[:expy] = expiration_year if expiration_year

    uri = "#{BASE_URI}/option_option?#{params.to_query}"
    resp = Http.get(uri)
    resp_status = resp.status.to_i
    return nil unless resp_status == 200
    string_resp = resp.body.to_s

    # Google's response isn't valgid JSON, so we gsub it before parsing
    formatted_resp = string_resp.gsub(/([\w]+):/, '"\1":')

    # Return the parsed JSON
    JSON.parse(formatted_resp, symbolize_names: true)
  rescue => e
    Rails.logger.error { "Encountered an error when trying to get_option_option"\
                         " of gid '#{gid}'. #{e.message}"\
                         " #{e.backtrace.join("\n")}" }
    nil
  end
end
