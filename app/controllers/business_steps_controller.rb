class BusinessStepsController < ApplicationController
	include Wicked::Wizard
	steps :financial, :funders
	before_filter :require_business
	before_filter :standardize_params, :only => [:update]

	def show
		@business = current_business
		skip_step if (step == :funders and (!@business.is_paying_back or !@business.qualified?))
		render_wizard
	end

	def update
		@business = current_business
		@business.current_step = step
		if @business.update(business_params)
			if @business.update_step(step)
				if Rails.env.production?
				  @business.deliver_activation_instructions! 
				  @business.deliver_qualified_signup!
				else
				  @business.is_email_confirmed = true
				end
				@business.create_offers(12)
				@business.save
			end
		end
		render_wizard @business
	end

    def finish_wizard_path
	  	business_path(@business)
	end
	
	private

		def business_params
			if step == :financial
				puts "========== financial"
				return params.require(:business).permit(:id, :is_paying_back, 
	    		:approximate_credit_score_range, :is_tax_lien, :is_payment_plan,
	    		:is_ever_bankruptcy, :average_daily_balance_bank_account,
	    		:amount_negative_balance_past_month, :years_in_business, :business_type_id,
	    		:years_in_business, :is_judgement) 
			elsif step == :personal
				puts "================== personal"
				return params.require(:business).permit(:id, :owner_first_name, 
				:owner_last_name, :name, :phone_number, :street_address_one, 
				:street_address_two, :city, :state, :business_type)
			elsif step == :funders
				puts "============== funders"
				return params.require(:business).permit(:id, :previous_merchant, 
	    		:total_previous_payback_amount, :total_previous_payback_balance)
	    	end
	    end


	    def standardize_params
	    	if step == :personal
	    		params[:business][:phone_number] = params[:business][:phone_number].gsub(/\D/, "")
	    	elsif step == :funders
	      		params[:business][:total_previous_payback_amount].gsub!( /[^\d]/, '')
	      		params[:business][:total_previous_payback_balance].gsub!( /[^\d]/, '')
	    	elsif step == :financial
	    		params[:business][:average_daily_balance_bank_account].gsub!( /[^\d.]/, '').slice!(".00")
	    	end	
	    end
end
