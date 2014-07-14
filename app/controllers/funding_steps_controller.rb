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
			is_signup = (flash[:signup] == true)
			funding_type = "funder"
			funding_type = "renew" if @business.is_refinance
			pluggable_js(is_production: is_production, step: step, is_signup: is_signup, email: @business.business_user.email, business_name: @business.name, funding_type: funding_type)
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
				track_mixpanel_errors(@bank_account, step)
				render_wizard @bank_account
			end
		else
			if @business.update_attributes(business_params)
				if step == :personal
					flash[:personal_passed] = true
				end
			end
			@business.assign_attributes(business_params)
			track_mixpanel_errors(@business, step)
			render_wizard @business
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



	def track_mixpanel_errors(object, step)
		unless object.valid?
			humanized_keys = get_errors_humanized(object, step)
			humanized_keys.each do |keys|
				MixpanelLib.track(current_business.email, "Error - #{keys} Input")
			end
		end
	end

	def get_errors_humanized(object, step)
		humanized_keys = []
		object.errors.keys.each do |key|
			humanized_keys << humanized_hash_keys(step)[key]
		end
		return humanized_keys
	end
	
	def humanized_hash_keys(step)
		case step
		when :personal
			return {:years_in_business => "Years in Business", :owner_first_name => "Owner's First Name", :owner_last_name => "Owner's Last Name", 
				:street_address_one => "Street Address One", :street_address_two => "Street Address Two", :city => "City", :location_state => "State", :mobile_number => "Mobile Number", :zip_code => "Zip Code", :phone_number => "Phone Number", 
				:business_type_id => "Business Type"}
		when :refinance
			return {:deal_type => "Deal Type", :previous_merchant_id => "Current Funder", :previous_loan_date => "Current Loan Start Date", :total_previous_loan_amount => "Current MCA Given Amount",
	    		:total_previous_payback_amount => "Current MCA Payback Amount", :is_closing_fee => "Closing Fee", :closing_fee => "Closing Fee Amount", :total_previous_payback_balance => "Current MCA Balance"}
		when :financial
			return {:approximate_credit_score_range => "Credit Score", :is_tax_lien => "Tax Lien", :is_payment_plan => "Tax Lien Payment Plan",
	    		:is_ever_bankruptcy => "Bankruptcy", :is_judgement => "Judgement"}
		when :bank_prelogin
			return {:account_number => "Account Number", :routing_number => "Routing Number"}
		end
	end

end

