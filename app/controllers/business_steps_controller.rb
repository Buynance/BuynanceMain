class BusinessStepsController < ApplicationController
	include Wicked::Wizard
	steps :personal, :financial_information, :past_merchants
	before_filter :require_business

	def show
		@business = current_business

		skip_step if (step == :past_merchants and !@business.is_paying_back)
		render_wizard
	end

	def update
		@business = current_business
		
		if business_params[:is_paying_back] == 0
			business_params[:is_paying_back] = false
		else
			business_params[:is_paying_back] = true
		end

		if business_params[:is_tax_lien] == 0
			business_params[:is_tax_lien] = false
		else
			business_params[:is_tax_lien] = true
		end

		standardize_params if step == :past_merchants || step == :financial_information

		if @business.update(business_params)
			if step == :personal
				@business.passed_personal_information = true 	
			elsif step == :financial_information
				#@business.passed_financial_information = true
				if !@business.is_paying_back
					@business.is_finished_application = true
	 				@business.deliver_activation_instructions!
				end
			elsif step == :past_merchants
				@business.passed_merchant_history = true
				@business.is_finished_application = true
	 			@business.deliver_activation_instructions! if @business.has_paid_enough
			end

		end
		
		@business.save
		render_wizard @business
	end

	def finish_wizard_path
  		business_path(@business)
	end

	def business_params
    	params.require(:business).permit(:id, :name, :email, :password, 
    		:password_confirmation, :owner_first_name, :owner_last_name, 
    		:open_date, :is_authenticated, :is_accepting, :is_accept_credit_cards, 
    		:phone_number, :street_address_one, :street_address_two, :city, 
    		:state, :zip_code, :is_paying_back, :previous_merchant_id, 
    		:total_previous_payback_amount, :total_previous_payback_balance, 
    		:is_email_confirmed, :earned_one_month_ago, :earned_two_months_ago, 
    		:earned_three_months_ago, :owner_first_name, :owner_last_name, 
    		:is_finished_application, :passed_merchant_history, 
    		:passed_personal_information, :most_recent_funder, :is_tax_lien, 
    		:business_type, :approximate_credit_score,  :approximate_credit_score_range, 
    		:is_payment_plan, :is_ever_bankruptcy, :average_daily_balance_bank_account, 
    		:amount_negative_balance_past_month)
    end


    def standardize_params
    	if step == :past_merchants
      		params[:business][:total_previous_payback_amount].gsub!( /\$/, '')
      		params[:business][:total_previous_payback_balance].gsub!(/\$/, '')
    	elsif step == :financial_information
    		params[:business][:average_daily_balance_bank_account].gsub(/\$/, '')
    	end	
    end
end
