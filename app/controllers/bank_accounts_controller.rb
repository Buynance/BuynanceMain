require 'decision_logic.rb'

class BankAccountsController < ApplicationController
	before_filter :require_business_user

	def new
		@iframe_code = '<iframe id="IFrameHolder" frameborder="0" height="450" width="900" src="https://widget.decisionlogic.com/Service.aspx?requestCode=#{@business.initial_request_code}"></iframe>'
	end

	def failure
		@business = current_business
		@business.bank_error_occured
		@business.error_bank_prelogin
	end

	def success
		@business = current_business
		if @business.bank_account.institution_name.nil?
			request_code = params[:requestCode]
			@report = DecisionLogic.get_report_detail_from_request_code_4(request_code)
			if(request_code == @report[:request_code] )
				@bank_account = @business.bank_account
				@bank_account.proccess_bank_information(@report)
				@business.accept_as_lead
				@bank_account.save
				redirect_to account_url
			else
			end
		else
			redirect_to controller: 'static_pages', action: 'error', error_code: 1004
		end
	end
end