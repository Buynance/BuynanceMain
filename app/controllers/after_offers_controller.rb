class AfterOffersController < ApplicationController
include Wicked::Wizard
	steps :personal
	before_filter :require_business
	before_filter :standardize_params, :only => [:update]

	def show
		@business = current_business
		render_wizard
	end

	def update
		@business = current_business
		@business.current_step = step
		if @business.update_attributes(business_params)
			
		end
		render_wizard @business
	end

    def finish_wizard_path
	  	business_path(@business)
	end
	
	private

		def business_params
			if step == :personal
				puts "================== personal"
				return params.require(:business).permit(:id, :owner_first_name, 
				:owner_last_name, :name, :phone_number, :street_address_one, 
				:street_address_two, :city, :state, :business_type)
			end
	    end


	    def standardize_params
	    	if step == :personal
	    		params[:business][:phone_number] = params[:business][:phone_number].gsub(/\D/, "")
	    		params[:business][:mobile_number] = params[:business][:mobile_number].gsub(/\D/, "")
	    	end	
	    end
end
