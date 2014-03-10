class BusinessStepsController < ApplicationController
	include Wicked::Wizard
	steps :personal, :past_merchants
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

		standardize_params if step == :past_merchants

		puts "#{business_params[:is_paying_back]}"
		if @business.update(business_params)
			if step == :personal
				puts "=================Updating Personal"
				puts "================== Is Paying Back #{@business.is_paying_back}"
				@business.passed_personal_information = true 
				if !@business.is_paying_back
					@business.is_paying_back = false
					puts "================Not paying back, account updated"
					@business.is_finished_application = true
					flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
	 				@business.deliver_activation_instructions!
	 				puts "=============== Emailed Activation after personal"
				end
			elsif step == :past_merchants
				@business.is_paying_back = true
				puts "=================Updating PAst Merchants"
				@business.passed_merchant_history = true
				@business.is_finished_application = true
				if @business.has_paid_enough
					flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
	 				@business.deliver_activation_instructions!
	 				puts "==================Emailed activation after past merchant"
				end
			end

		end
		
		@business.save
		render_wizard @business
	end

	def finish_wizard_path
  		business_path(@business)
	end

	def business_params
    	params.require(:business).permit(:id, :name, :email, :password, :password_confirmation, :owner_first_name, :owner_last_name, :open_date, :is_authenticated, :is_accepting, :is_accept_credit_cards, :phone_number, :street_address_one, :street_address_two, :city, :state, :zip_code, :is_paying_back, :previous_merchant_id, :total_previous_payback_amount, :total_previous_payback_balance, :is_email_confirmed, :earned_one_month_ago, :earned_two_months_ago, :earned_three_months_ago, :owner_first_name, :owner_last_name, :is_finished_application, :passed_merchant_history, :passed_personal_information, :most_recent_funder, :is_tax_lien, :business_type, :approximate_credit_score )
    end

    def standardize_params
      params[:business][:total_previous_payback_amount].gsub!( /\$/, '')
      params[:business][:total_previous_payback_balance].gsub!( /\$/, '')
    end
end
