class StaticPagesController < ApplicationController

	before_filter :send_production_js, only: [:index, :privacy, :tos, :blog, :about]
	
	def index
		
	end
	
	def privacy
		
	end
	
	def tos
	
	end
	
	def blog
	
	end
	
	def confirm_email
		@business = current_business
	end

  	def about
  	
  	end


	def error
		error_code = params[:error_code]
		@error_message = "OOOOPPPPS :)"
		case error_code
		when 1004
		  @error_message = "Your bank account is already created!!!!!!!!!!!"
		end
	end

	private

		
end
