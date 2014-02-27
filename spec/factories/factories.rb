FactoryGirl.define do
  factory :profitability do
    
    daily_merchant_cash_advance Random.rand(1_000)

    trait :monthly_collected_more_than_monthly_total do
      monthly = Random.rand(10_000..90_000)
      total = Random.rand(10_000..monthly)
      monthly_cash_collection_amount monthly
      total_monthly_bills total
    end

    trait :monthly_collected_less_than_monthly_total do 
      monthly = Random.rand(10_000..90_000)
      total = Random.rand(monthly..90_000) + 1
      monthly_cash_collection_amount monthly
      total_monthly_bills total
    end

    trait :monthly_collected_equals_monthly_total do 
      monthly = Random.rand(10_000..90_000)
      total = monthly
      monthly_cash_collection_amount monthly
      total_monthly_bills total
    end

    #user_more = build(:monthly_collected_more_than_monthly_total)
    #user_less = build(:monthly_collected_less_than_monthly_total)
    #user_equal = build(:monthly_collected_equals_monthly_total)

  end
end