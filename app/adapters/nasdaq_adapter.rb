class NasdaqAdapter
  require "http"
  require "csv"

  def get_all_stock_symbols
    results = []

    EXCHANGES.each { |exchange|
      symbols = get_stock_symbols_on exchange
      results = results | symbols
    }

    return results
  end

  def get_stock_symbols_on exchange
    params = {
      render: "download",
      exchange: exchange
    }

    uri = "#{BASE_URI}?#{params.to_query}"
    string_resp = Http.get(uri).body.to_s
    CSV.parse(string_resp, headers: true).map { |row|
      "#{exchange}:#{row["Symbol"]}"
    }
  end

  private

  BASE_URI = "http://www.nasdaq.com/screening/companies-by-industry.aspx".freeze
  EXCHANGES = ["NASDAQ", "NYSE", "AMEX"].freeze
end
