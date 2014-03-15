class BusinessStepsController < ApplicationController
	include Wicked::Wizard
	steps :personal, :financial_information, :past_merchants
	before_filter :require_business
	before_filter :standardize_params, :only => [:update]

	def show
		@business = current_business
		skip_step if (step == :past_merchants and !@business.is_paying_back)
		render_wizard
	end

	def update
		@business = current_business
		@business.current_step = step
		if @business.update(business_params)
			if @business.update_step(step)
				@business.deliver_activation_instructions!
			end
		end
		render_wizard @business
	end

    def finish_wizard_path
	  	business_path(@business)
	end
	
	private

		def business_params
			if step == :financial_information
				puts "========== financial_information"
				return params.require(:business).permit(:id, :is_paying_back, 
	    		:approximate_credit_score_range, :is_tax_lien, :is_payment_plan,
	    		:is_ever_bankruptcy, :average_daily_balance_bank_account,
	    		:amount_negative_balance_past_month) 
			elsif step == :personal
				puts "================== personal"
				return params.require(:business).permit(:id, :owner_first_name, 
				:owner_last_name, :name, :phone_number, :street_address_one, 
				:street_address_two, :city, :state, :business_type)
			elsif step == :past_merchants
				puts "============== past_merchants"
				return params.require(:business).permit(:id, :previous_merchant, 
	    		:total_previous_payback_amount, :total_previous_payback_balance)
	    	end
	    end


	    def standardize_params
	    	if step == :personal
	    		params[:business][:phone_number] = params[:business][:phone_number].gsub(/\D/, "")
	    	elsif step == :past_merchants
	      		params[:business][:total_previous_payback_amount].gsub!( /[^\d.]/, '').slice!(".00")
	      		params[:business][:total_previous_payback_balance].gsub!( /[^\d.]/, '').slice!(".00")
	    	elsif step == :financial_information
	    		params[:business][:average_daily_balance_bank_account].gsub!( /[^\d.]/, '').slice!(".00")
	    	end	
	    end
end
