require 'decision_logic.rb'

class BankAccountsController < ApplicationController
	before_filter :require_business_user

	def new
		@iframe_code = '<iframe id="IFrameHolder" frameborder="0" height="450" width="900" src="https://widget.decisionlogic.com/Service.aspx?requestCode=#{@business.initial_request_code}"></iframe>'
	
	end

	def found
		business = current_business
		bank_account = business.bank_account
		bank_account.populate

	end

	def success
		@business = current_business
		if @business.bank_account.institution_name.nil?
			request_code = params[:requestCode]
			@report = DecisionLogic.get_report_detail_from_request_code_4(request_code)
			@is_error = false
			if(request_code == @report[:request_code] )
				@bank_account = BankAccount.new
				@bank_account.populate_from_report4(@report)
				@bank_account.retrieve_bank_information
				@bank_account.save
				@bank_account.add_transactions_from_report4(@report)
				@bank_account.add_transaction_summaries_from_report4(@report)
				@bank_account.calculate_last_three_months_deposits
				@bank_account.calculate_last_three_months_daily_balance
				@bank_account.total_negative_days = @bank_account.get_negative_days
				@business.bank_account = @bank_account
				@business.accept_as_lead
				@bank_account.save
				redirect_to account_url
			else
				@is_error = true
				@output = "POOOP"
			end
		else
			redirect_to controller: 'static_pages', action: 'error', error_code: 1004
		end
	end
end