require 'decision_logic.rb'
class FundingStepsController < ApplicationController
	include Wicked::Wizard

	steps :personal, :refinance, :financial, :bank_prelogin, :bank_information
	before_filter :require_business_user
	
	def show
		@business = current_business
		case step
		when :refinance
			skip_step unless @business.is_refinance == true
			render_wizard
		when :bank_prelogin
			@bank_account = BankAccount.new
			render_wizard
		when :bank_information
			if @business.create_request_code
				@business.bank_account.create_first_request_code
				render_wizard
			else
				redirect_to wizard_path(:bank_prelogin), notice: "Your routing number and/or account number are incorrect."
			end
		else
			render_wizard
		end

		#@business = current_business
		#@bank_account = BankAccount.new if step == :bank_prelogin
		#if step == :refinance
		#	skip_step unless @business.is_refinance == true
		#	render_wizard
		#elsif step == :bank_information
		#    @business.initial_request_code = DecisionLogic.get("https://www.decisionlogic.com/CreateRequestCode.aspx?serviceKey=QBZKMWHRHND5&profileGuid=9538c1e4-2a44-4eca-9587-e5d5bd1fcf65&siteUserGuid=76246387-0c72-401a-b629-b5b102859bb3&customerId=&firstName=#{@business.owner_first_name}&lastName=#{@business.owner_last_name}&routingNumber=#{@business.bank_account.routing_number}&accountNumber=#{@business.bank_account.account_number}") 
		#	unless @business.initial_request_code.length > 20
		#		@business.bank_account.create_first_request_code
		#		@business.save
		#		render_wizard
		#	else
		#		redirect_to wizard_path(:bank_prelogin), notice: "Your routing number and/or account number are incorrect."
		#	end
		#else
		#	render_wizard
		#end
		
	end

	def update
		@business = current_business
		@business.current_step = step
		if step == :bank_prelogin
			if @business.bank_account.nil?
				@bank_account = BankAccount.new(bank_account_params)
				@bank_account.current_step = step
				@bank_account.save
				@bank_account.business_id = @business.id
			else
				@bank_account = @business.bank_account
				@bank_account.assign_attributes(bank_account_params)
			end
			render_wizard @bank_account
		else
			@business.update_attributes(business_params)
			render_wizard @business
		end	
	end

	private

	def business_params
		return params.require(:business).permit( :years_in_business, :owner_first_name, :owner_last_name, 
			:street_address_one, :street_address_two, :city, :location_state, :mobile_number, :zip_code, :phone_number, 
			:business_type_id) if step == :personal
		return params.require(:business).permit(:deal_type, :previous_merchant_id, :previous_loan_date, :total_previous_loan_amount,
	    		:total_previous_payback_amount, :is_closing_fee, :closing_fee)  if step == :refinance
		return params.require(:business).permit(:approximate_credit_score_range, :is_tax_lien, :is_payment_plan,
	    		:is_ever_bankruptcy, :is_judgement)  if step == :financial
		return params.require(:business).permit(:bank_accounts_attributes => [:account_number, :routing_number]) if step == :bank_prelogin
	end

	def bank_account_params
		return params.require(:bank_account).permit(:account_number, :routing_number) if step == :bank_prelogin		
	end
end

