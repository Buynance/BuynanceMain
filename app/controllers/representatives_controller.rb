class RepresentativesController < ApplicationController
	def add_business
		@business = Business.new
		@business_user = BusinessUser.new
		@representative = Representative.new
	end

	def add_business_action
		representative = Representative.find_by(email: representative_params[:email])
		@business = Business.new(business_params)
		@business_user = BusinessUser.new(business_user_params)
		unless representative.nil? 
			if @business_user.valid? && @business.valid?
	      		@business_user.save
	      		@business.save
	      		flash[:success] = "A new user was successfully added."
	      		redirect :action => :new
	        else
	        	render :action => :new
	        end
	    else
	    	flash[:alert] = "Your email was not found."
	    	render :action => :new
	    end
	end

	private

	def business_user_params
      return params.require(:business_user).permit(:email, 
        :password, :password_confirmation) 
    end

    def business_params
      return params.require(:business).permit(:name, :is_refinance, :years_in_business, :owner_first_name, :owner_last_name, 
			:street_address_one, :street_address_two, :city, :location_state, :mobile_number, :zip_code, :phone_number, 
			:business_type_id, :mobile_disclaimer, :deal_type, :previous_merchant_id, :previous_loan_date, :total_previous_loan_amount,
	    	:total_previous_payback_amount, :is_closing_fee, :closing_fee, :total_previous_payback_balance, :approximate_credit_score_range, :is_tax_lien, :is_payment_plan,
	    	:is_ever_bankruptcy, :is_judgement)
    end

    def representative_params
    	return params.require(:business).permit(:email)
    end
end