require 'decision_logic.rb'
require 'mixpanel_lib'

class FundingStepsController < ApplicationController
	include Wicked::Wizard

	steps :personal, :refinance, :financial, :bank_prelogin, :bank_information
	before_filter :require_business_user
	before_filter :standardize_params, :only => [:update]
	before_filter :set_business_step, only: [:show]
	before_filter :send_javascript, only: [:show]
	
	def show	
		@business = current_business
		case step
		when :personal
			render_wizard
		when :financial
			render_wizard
		when :refinance
			skip_step unless @business.is_refinance
			render_wizard
		when :bank_prelogin
			@bank_account = BankAccount.new
			render_wizard
		when :bank_information
			if @business.create_request_code
				render_wizard
			else
				redirect_to wizard_path(:bank_prelogin), notice: "Your routing number and/or account number are incorrect."
			end
		else
			render_wizard
		end
	end

	def update
		@business = current_business
		@business.current_step = step
		if step == :bank_prelogin
			if @business.bank_account.nil?
				@bank_account = BankAccount.new(bank_account_params)
				if @business.is_refinance
					if @bank_account.routing_number == "skip"
						@business.accept_as_lead
						@business.qualify_for_market
						redirect_to account_url
					elsif @bank_account.routing_number == "market"
						@business.accept_as_lead
						@business.qualify_for_market
						redirect_to account_url	
					else
						@bank_account.current_step = step
						@bank_account.business_id = @business.id
						@bank_account.save
						render_wizard @bank_account
					end
				else
					if @bank_account.routing_number == "market"
						@business.accept_as_lead
						@business.qualify_for_market
						redirect_to account_url
					elsif @bank_account.routing_number == "funder"
						@business.accept_as_lead
						@business.qualify_for_funder
						redirect_to account_url
					else
						@bank_account.current_step = step
						@bank_account.business_id = @business.id
						@bank_account.save
						render_wizard @bank_account
					end
				end
				
			else
				@bank_account = @business.bank_account
				@bank_account.assign_attributes(bank_account_params)
				log_input_error(@bank_account, "Signup #{step.to_s.titleize}")
				render_wizard @bank_account
			end
		else
			if @business.update_attributes(business_params)
				if step == :personal
					if @business.years_in_business == 0
						@business.disqualify!
						@business.save
						redirect_to account_url
					else
						flash[:personal_passed] = true
						render_wizard @business
					end
				else
					render_wizard @business
				end
			else
				log_input_error(@business, "Signup #{step.to_s.titleize}")
				render_wizard @business
			end
		end	
	end

	def finish_wizard_path
  		account_url
	end

	private

	def business_params
		return params.require(:business).permit( :years_in_business, :owner_first_name, :owner_last_name, 
			:street_address_one, :street_address_two, :city, :location_state, :mobile_number, :zip_code, :phone_number, 
			:business_type_id, :mobile_disclaimer) if step == :personal
		return params.require(:business).permit(:deal_type, :previous_merchant_id, :previous_loan_date, :total_previous_loan_amount,
	    		:total_previous_payback_amount, :is_closing_fee, :closing_fee, :total_previous_payback_balance)  if step == :refinance
		return params.require(:business).permit(:approximate_credit_score_range, :is_tax_lien, :is_payment_plan,
	    		:is_ever_bankruptcy, :is_judgement)  if step == :financial
		return params.require(:business).permit(:bank_accounts_attributes => [:account_number, :routing_number]) if step == :bank_prelogin
	end

	def bank_account_params
		return params.require(:bank_account).permit(:account_number, :routing_number) if step == :bank_prelogin		
	end

	def standardize_params
	    if step == :refinance
	      	params[:business][:total_previous_payback_amount].gsub!( /[^\d]/, '')
	      	params[:business][:total_previous_payback_balance].gsub!( /[^\d]/, '')
	      	params[:business][:closing_fee].gsub!( /[^\d]/, '')
	      	params[:business][:total_previous_loan_amount].gsub!( /[^\d]/, '')
	    end	
	end

	def set_business_step
		case step
		when :personal
		when :refinance
			current_business.passed_personal
			current_business.passed_revise if current_business.is_refinance	
		when :financial
			current_business.passed_revise
		when :bank_prelogin
			current_business.passed_financial
		when :bank_information
			current_business.passed_bank_prelogin
		end
	end

	def send_javascript
		funding_type = ("revise" if current_business.is_refinance) || ("funder")
		if (step == :financial or step == :refinance)
			pluggable_js(is_production: is_production, step: step, email: current_business.business_user.email, business_name: current_business.name, funding_type: funding_type, mobile_disclaimer_accepted: true, name: "#{current_business.owner_first_name} #{current_business.owner_last_name}")
		else
			pluggable_js(is_production: is_production, step: step, email: current_business.business_user.email, business_name: current_business.name, funding_type: funding_type)
		end
	end
end

