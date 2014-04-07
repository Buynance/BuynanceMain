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

  factory :business do 
    loan_reason_id "1"
    terms_of_service "1"

    trait :deposit_over_minimum do
      earned_one_month_ago 6000
      earned_two_months_ago 6000
      earned_three_months_ago 6000
    end

    trait :deposit_under_minimum do
      earned_one_month_ago 4000
      earned_two_months_ago 4000
      earned_three_months_ago 4000
    end

    trait :valid_financial_inputs do
      deposit_over_minimum
      current_step :financial
      is_paying_back true
      business_type_id 0
      years_in_business 5
      approximate_credit_score_range 5
      is_tax_lien false
      is_ever_bankruptcy false
      is_judgement false
      average_daily_balance_bank_account 5000
      amount_negative_balance_past_month 0
    end

    trait :valid_funder_inputs do
      valid_financial_inputs
      current_step :funder
      previous_merchant "Other"
      total_previous_payback_amount 50000
      total_previous_payback_balance 20
    end

    trait :one_year_old_and_under do
      valid_financial_inputs
      years_in_business 1
    end

    trait :minimum_credit_score do
      valid_financial_inputs
      approximate_credit_score_range 0
    end

    trait :is_tax_lien_and_not_paying_back do
      valid_financial_inputs
      is_tax_lien true
      is_paying_back false
    end

    trait :with_bankruptcy do
      valid_financial_inputs
      is_ever_bankruptcy true
    end

    trait :with_judgement do
      valid_financial_inputs
      is_judgement true
    end

    trait :amount_negative_higher_than_three do
      valid_financial_inputs
      amount_negative_balance_past_month 4
    end

    trait :payback_amount_less_than_40_percent do
      valid_funder_inputs
      total_previous_payback_balance (50000.0 * 0.5)
    end

  end
end