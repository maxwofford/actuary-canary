nasdaq = NasdaqAdapter.new
gfinance = GoogleFinanceAdapter.new

# Populate stock symbols
symbols = nasdaq.get_all_stock_symbols
symbols.each do |symbol|
  gid = gfinance.get_gid_by_symbol symbol
  share_price = gfinance.get_price_by_gid gid

  Stock.create(symbol: symbol, gid: gid, share_price: share_price)
end
