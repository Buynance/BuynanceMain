require 'decision_logic.rb'
require 'mixpanel_lib'

class FundingStepsController < ApplicationController
	include Wicked::Wizard

	steps :personal, :refinance, :financial, :bank_prelogin, :bank_information
	before_filter :require_business_user
	before_filter :standardize_params, :only => [:update]
	
	def show	
		@business = current_business
		
		if step != :disclaimer and @business.awaiting_disclaimer_acceptance?
			jump_to(:disclaimer)
		end
		
		case step
		when :personal
			funding_type = "funder"
			funding_type = "renew" if @business.is_refinance
			pluggable_js(is_production: is_production, step: step, is_signup: (flash[:signup] == true), email: @business.business_user.email, business_name: @business.name, funding_type: funding_type)
			render_wizard
		when :financial
			pluggable_js(is_production: is_production, step: step, personal_passed: (flash[:personal_passed] == true), mobile_disclaimer_accepted: @business.mobile_disclaimer)
			render_wizard
		when :refinance
			pluggable_js(is_production: is_production, step: step, personal_passed: (flash[:personal_passed] == true), mobile_disclaimer_accepted: @business.mobile_disclaimer)
			skip_step unless @business.is_refinance == true
			render_wizard
		when :bank_prelogin
			pluggable_js(is_production: is_production, step: step)
			@bank_account = BankAccount.new
			render_wizard
		when :bank_information
			pluggable_js(is_production: is_production, step: step)
			if @business.create_request_code
				@business.bank_account.create_first_request_code
				render_wizard
			else
				redirect_to wizard_path(:bank_prelogin), notice: "Your routing number and/or account number are incorrect."
			end
		else
			pluggable_js(is_production: is_production, step: step)
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
				log_input_error(@bank_account, "Signup #{step.to_s.titlelize}")
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
end

