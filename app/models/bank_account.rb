# Questions: Do transaction go from old to new or the oposite. This will change scopes. We want the first transaction to be the newest

class BankAccount < ActiveRecord::Base
	include BankAccountValidations
	 attr_accessor :current_step

	serialize :all_request

	has_many :transactions, :dependent => :destroy
	has_many :transaction_summaries, :dependent => :destroy


	DAYS_ENOUGH_TRANSACTIONS = 60

	#scope :transactions_past_month, includes(:transactions).where("transactions.transaction_date > ?", DateTime.now.change(month: (DateTime.now.month - 1)))
	#scope :transactions_past_month_from_last_transaction, includes(:transactions).where("transactions.transaction_date > ?", self.transactions.last.transaction_date.change(month: (self.transactions.last.transaction_date.month - 1)))
	
	state_machine :state, :initial => :awaiting_request_code do

		event :create_first_request_code do
			transition [:awaiting_request_code] => :first_request_code_created
		end

		event :retrieve_bank_information do
			transition [:first_request_code_created] => :bank_information_retrieved
		end

	end

	def self.status
		return {bank_error: -2, account_error: -1, not_started: 0, started_not_completed: 1, login_not_verified: 2, login_verified: 3}
	end

	def populate_from_report4(report)
		self.account_number = report[:account_number_found]
		self.institution_name = report[:institution_name]
		self.average_balance = report[:average_balance]
		self.average_recent_balance = report[:average_recent_balance]
		self.total_credit_transactions = report[:total_credits]
		self.total_debit_transactions = report[:total_debits]
		self.available_balance = report[:available_balance]
		self.is_transactions_available = report[:is_activity_available]
		self.as_of_date = DateTime.now
		self.transactions_from_date = report[:activity_start_date]
		self.transactions_to_date = report[:activity_end_date]
		self.current_balance = report[:current_balance]

	end

	def add_transactions_from_report4(report)
		report[:transaction_summaries][:transaction_summary3].each do |transaction|
			transaction_model = Transaction.new do |t|
				t.transaction_date = transaction[:transaction_date]
				t.amount = transaction[:amount]
				t.running_balance = transaction[:running_balance]
				t.description = transaction[:description]
				t.status = transaction[:status]
				t.is_refresh = transaction[:is_refresh]
				t.type_code = transaction[:type_codes]
			end
			self.transactions << transaction_model
		end
	end

	def add_transaction_summaries_from_report4(report)
		report[:transaction_analysis_summaries][:transaction_analysis_summary3].each do |transaction_summary|
			transaction_summary_model = TransactionSummary.new do |t_s|
				t_s.type_name = transaction_summary[:type_name]
				t_s.type_code = transaction_summary[:type_code]
				t_s.total_count = transaction_summary[:total_count]
				t_s.total_amount = transaction_summary[:total_amount]
				t_s.recent_count = transaction_summary[:recent_count]
				t_s.recent_amount = transaction_summary[:recent_amount]
			end

			self.transaction_summaries << transaction_summary_model
		end
	end
	


	def get_negative_days
		negative_transactions = transactions.where("running_balance < ?", 0)
		count = 0
		start_date = negative_transactions[0].transaction_date.to_date + 1
		negative_transactions.each do |negative|
			if negative.running_balance < 0 and negative.transaction_date.to_date != start_date
				count = count + 1
				start_date = negative.transaction_date.to_date
			end
		end
		return count
	end

	def months_of_transactions
		return ( days_of_transactions / 30).to_f
	end

	def get_negative_days_monthly_average
		return get_negative_days() / months_of_transactions
	end

	def total_deposits_value
		return (self.deposits_one_month_ago + self.deposits_two_months_ago + self.deposits_three_months_ago)
	end

	def total_number_of_deposits
		return get_transactions_by_type_code("dp").size
	end

	def days_of_transactions
		return (self.transactions[0].transaction_date.to_date - self.transactions.last.transaction_date.to_date)
	end





	def calculate_last_three_months_deposits
		monthly_deposit_array = [0,0,0,0,0,0]
		start_date = transactions[0].transaction_date.to_date
		total_month_deposit = 0
		deposit_transactions = get_transactions_by_type_code("dp")
		deposit_transactions.each do |transaction|
			days_away = start_date - transaction.transaction_date.to_date
			month = days_away / 30
			monthly_deposit_array[month] = transaction.amount + monthly_deposit_array[month]
		end

		self.deposits_one_month_ago = monthly_deposit_array[0]
		self.deposits_two_months_ago = monthly_deposit_array[1]
		self.deposits_three_months_ago = monthly_deposit_array[2]
		return monthly_deposit_array
	end

	def deposit_average_atleast(amount, is_last_three = false)	
		deposit_sum = self.deposits_one_month_ago + self.deposits_two_months_ago
		(deposit_sum = deposit_sum + self.deposits_three_months_ago) if is_last_three
		return true if (deposit_sum / 2.0) >= amount
		return_value = false
	end

	def average_daily_balance_atleast(amount, is_last_three = false)
		deposit_sum = self.average_balance_one_month_ago + self.average_balance_two_months_ago
		(deposit_sum = deposit_sum + self.average_balance_three_months_ago) if is_last_three
		return true if (deposit_sum / 2.0) >= amount
		return_value = false
	end

	def calculate_last_three_months_daily_balance
		monthly_daily_balance_array = [0,0,0]
		monthly_transaction_array = [0,0,0]
		start_date = transactions[0].transaction_date.to_date
		#total_month_daily_balance
		#total_month_days
		transactions.each do |transaction|
			days_away = start_date - transaction.transaction_date.to_date
			month = days_away / 30
			monthly_daily_balance_array[month] = transaction.running_balance + monthly_daily_balance_array[month]
			monthly_transaction_array[month] = 1 + monthly_transaction_array[month]
		end

		(0...monthly_daily_balance_array.length).each do |i|
			monthly_daily_balance_array[i] = monthly_daily_balance_array[i] / monthly_transaction_array[i]
		end

		self.average_balance_one_month_ago = monthly_daily_balance_array[0]
		self.average_balance_two_months_ago = monthly_daily_balance_array[1]
		self.average_balance_three_months_ago = monthly_daily_balance_array[2]
	end

	def get_transactions_by_type_code(type_code)
		return self.transactions.where("type_code like ?", "%#{type_code}%")
	end
	
	def average_deposits_amount_last_x_days(days)
		
		return false if self.last_reset.to_date > (self.transactions.last.transaction_date.to_date + days - 7)

		start_date = self.last_reset.to_date
		end_date = start_date - days
		sum = 0

		transactions = self.transactions.where("transaction_date.to_date > ? AND transaction_date.to_date <= ?", end_date, start_date)
		debit_transactions = Transaction.get_transactions_by_type_from_array(transactions, "dp")
		debit_transactions.each do |t|
			sum = sum + t.amount
		end
		return (sum / days)
	end

	def negative_balance_amount_past_month_from_last_transaction
		return get_negative_days_from_transactions(self.transactions_past_month_from_last_transaction)
	end

	def negative_balance_amount_past_month
		return get_negative_days_from_transactions(self.transactions_past_month)
	end

	def populate
		report = DecisionLogic.report_detail_from_request_code_4(self.all_request.last)
		varaible_hash = map_hash(report, {"account_number_found" => "account_number", "routing_number_entered" => "routing_number", "insitution_name" => "insitution_name", "activity_start_date" => "transactions_from_date", "activity_end_date" => "transactions_to_date", "average_balance" => "average_balance",
			"average_balance_recent" => "average_recent_balance", "as_of_date" => "as_of_date", "total_credits" => "total_credit_transactions", "total_debits" => "total_debit_transactions",
			"available_balance" => "available_balance", "is_activity_available" => "is_transactions_available"})
		self.update_attributes(variable_hash)
		self.create_transactions_from_hash(report)
	end

	def create_request_code
		business = Business.find(self.business_id, no_obfuscated_id: true)
		service_key = Buynance::Application.config.service_key
		profile_guid = Buynance::Application.config.profile_guid
		site_user_guid = Buynance::Application.config.site_user_guid 
		customer_id = business.email

		if self.awaiting_request_code?
			request_url = "https://www.decisionlogic.com/CreateRequestCode.aspx?serviceKey=#{service_key}&profileGuid=#{profile_guid}&siteUserGuid=#{site_user_guid}&customerId=#{customer_id}"
		else
			request_url = "https://www.decisionlogic.com/CreateRequestCode.aspx?serviceKey=#{service_key}&profileGuid=#{profile_guid}&siteUserGuid=#{site_user_guid}&customerId=#{customer_id}&firstName=#{business.owner_first_name}&lastName=#{business.owner_last_name}&accountNumber=#{self.account_number}&routingNumber=#{self.routing_number}&contentServiceId=#{self.institution_number}"
		end
		
		request_code = DecisionLogic.get(request_url)

		if request_code.length == 6
			self.all_request << request_code
		end

		return request_code 
	end

	def create_transactions_from_hash(hash)
		transactions_array = get_transactions_from_hash(hash)
		transactions_array.each do |transaction_hash|
			tranasaction = Transacion.new(
				transaction_date: DecisionLogic.xml_to_ruby_datetime(transaction_hash[:transaction_date]),
				amount: transaction_hash[:amount],
				running_balance: transaction_hash[:running_balance],
				description: transaction_hash[:description],
				is_refresh: transaction_hash[:is_refresh],
				status: transaction_hash[:status]
			)
			transaction.save
			type_codes = transaction_hash[:type_codes].split(',')
			type_codes.each do |type_code|
				new_type_code = TypeCode.find_or_create_by(type_code: type_code, summary: get_description_from_type_code(type_code))
				transaction.type_codes << new_type_code
			end
		end
	end

	def instant_refresh
		DecisionLogic.instant_refresh(self.all_request.last)
	end

	def enough_information_to_underwrite
		return [false, 100, "Transaction information unavailable", 0] if self.is_transactions_available == false
		return [false, 101, "Not enough transactions available", self.amount_days_of_transactions] if self.amount_days_of_transactions < DAYS_ENOUGH_TRANSACTIONS
	end

	private

	def amount_days_of_transactions
		return (self.transactions[0].transaction_date - self.transactions.last.transaction_date).to_i
	end

	def add_type_to_transaction(transaction, type_code)
		new_type_code = TypeCode.find_or_create_by(type_code: type_code, summary: get_description_from_type_code(type_code))
		transaction.type_codes << new_type_code
	end

	def get_transactions_from_hash(hash)
		return hash[:transaction_summaries][:transaction_summary3]
	end

	def get_transaction_summaries_from_hash(hash)
		return hash[:transaction_analysis_summaries][:transaction_analysis_summary3]
	end

	#T
	def map_hash(hash, map_hash)
		return_hash = Hash.new
		map_hash.keys.each do |key|
			return_hash[map_hash[key].to_sym] = hash[key] if hash.has_key?(key)
		end
		return return_hash
	end

	def get_negative_days_from_transactions(transactions)
		negative_amount = 0
		last_negative_day = DateTime.now.to_date
		transactions.each do |transaction|
			if transaction.running_balance < 0
				if negative_amount == 0
					last_negative_day = transaction.transaction_date.to_date
					negative_amount = negative_amount + 1
				else
					unless(transaction.transaction_date.to_date.to_s === last_negative_day.to_s)
						last_negative_day = transaction.transaction_date.to_date
						negative_amount = negative_amount + 1
					end
				end
			end
		end
		negative_amount
	end

	def transaction_count_past_x_month(months_ago, transaction_array = self.transactions)
		transaction_count_array = Array.new(months_ago)

		(0...months_ago).each do |x|
			start_date = transaction_array[0].transaction_date << x
			end_date = (transaction_array[0].transaction_date << (x+1)) - 1
			transaction_count_array[x] = (transaction_array.select{|transaction| (transaction.transaction_date.to_date <= start_date and transaction.transaction_date.to_date > end_date)}).count
		end	
		return transaction_count_array

	end
	
	def transactions_last_x_days(days)
		return self.transactions.select{|deposit| self.last_reset.to_date < (deposit.transaction_date.to_date + days) } 
	end



end