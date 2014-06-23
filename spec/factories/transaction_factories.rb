FactoryGirl.define do

  sequence :transaction_date do |n|
  	DateTime.now << 1
  end	

  sequence :amount do |n|
  	500 * Random.rand * (-1 ** n)
  end

  factory :transaction do
  	transaction_date  {DateTime.now}
  	amount            100
  	running_balance   100
  	description       "Food"
  	is_refresh        false
  	status            "posted"
  end
end