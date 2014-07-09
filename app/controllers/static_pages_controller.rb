class StaticPagesController < ApplicationController
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

	def offer
		client = Aggcat.scope("123")
		@institutions = client.discover_and_add_accounts(100000, "direct", "mail")
		#@institutions = client.institutions

		#client.delete_customer
		#start_date = Date.today - 180
		#end_date = Date.today
		#@transactions = client.account_transactions(400027512466, start_date)
  end

	def add_user

		#client = 
	end

  def error
    error_code = params[:error_code]
    @error_message = "OOOOPPPPS :)"
    case error_code
    when 1004
      @error_message = "Your bank account is already created!!!!!!!!!!!"
    end
  end
end
