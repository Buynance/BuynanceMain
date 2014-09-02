class DialerDashboardsController < ApplicationController

	layout "dialer_layout"

	def home
		

	end

	def account
		@representative = current_rep_dialer
	end

	def setup
		@representative = current_rep_dialer

	end

	def setup_action
		@representative = current_rep_dialer
		if @representative.update_attributes(representative_params)
			@representative.add_paypal
			redirect_to action: :account
		else
			render action: :setup
		end

	end

	private

	def representative_params
      return params.require(:rep_dialer).permit(:paypal_email) 
    end

end
