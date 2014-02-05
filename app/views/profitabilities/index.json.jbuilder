json.array!(@profitabilities) do |profitability|
  json.extract! profitability, :id, :daily_cash_collection_amount, :gross_profit_margin, :projected_daily_profit
  json.url profitability_url(profitability, format: :json)
end
