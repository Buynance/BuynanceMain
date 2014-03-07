class BusinessStepsController < ApplicationController
	include Wicked::Wizard
	steps :personal, :past_merchants

	def show
		@business = current_business

		skip_step if (step == :past_merchants and !@business.is_paying_back)
		render_wizard
	end

	def update
		@business = current_business
		if step == :personal
			params[:business][:passed_personal_information] = true 
			if !params[:business][:is_paying_back]
				params[:business][:is_finished_application]  = true
				flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
 				@business.deliver_activation_instructions!
			end
		end
		if step == :past_merchants
			params[:business][:passed_merchant_history] = true
			params[:business][:is_finished_application] = true
			flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
 			@business.deliver_activation_instructions!
		end
		@business.update(business_params)
		render_wizard @business
	end

	def finish_wizard_path
  		business_path(@business)
	end

	def business_params
    	params.require(:business).permit(:id, :name, :email, :password, :password_confirmation, :owner_first_name, :owner_last_name, :open_date, :is_authenticated, :is_accepting, :is_accept_credit_cards, :phone_number, :street_address_one, :street_address_two, :city, :state, :zip_code, :is_paying_back, :previous_merchant_id, :total_previous_payback_amount, :total_previous_payback_balance, :is_email_confirmed, :earned_one_month_ago, :earned_two_months_ago, :earned_three_months_ago, :owner_first_name, :owner_last_name, :is_finished_application, :passed_merchant_history, :passed_personal_information)
    end
end
