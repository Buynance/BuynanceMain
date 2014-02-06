json.array!(@profitabilities) do |profitability|
  json.extract! profitability, :id, :monthly_cash_collection_amount, :gross_profit_margin, :projected_monthly_profit
  json.url profitability_url(profitability, format: :json)
end
