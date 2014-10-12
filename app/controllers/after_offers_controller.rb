class AfterOffersController < ApplicationController
include Wicked::Wizard
	steps :personal, :offer_accepted
	before_filter :require_business_user
	before_filter :standardize_params, :only => [:update]

	def show
		@business = current_business
		render_wizard
	end

	def update
		@business_user = current_business_user
		@business = Business.find(@business_user.business_id)
		@business_user.current_step = step
		@business.current_step = step

		if @business.update_attributes(business_params)
			if step == :personal
				@business_user.update_attributes(first_name: business_params[:owner_first_name], last_name: business_params[:owner_last_name], mobile_number: business_params[:mobile_number])
				@business.deliver_offer_email!
				@business.submit_offer
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
			if step == :personal
				return params.require(:business).permit(:id, :owner_first_name, 
				:owner_last_name, :name, :phone_number, :street_address_one, 
				:street_address_two, :city, :state, :business_type, :mobile_number)
			end
	    end


	    def standardize_params
	    	if step == :personal
	    		params[:business][:phone_number] = params[:business][:phone_number].gsub(/\D/, "")
	    		params[:business][:mobile_number] = params[:business][:mobile_number].gsub(/\D/, "")
	    	end	
	    end
end
