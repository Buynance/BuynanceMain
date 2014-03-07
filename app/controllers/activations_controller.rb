class ActivationsController < ApplicationController
  def create
  	@business = Business.find_by_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @business.active?

    if @business.activate!
    	flash[:notice] = "Your account has been activated!"
        BusinessSession.create(@business, false) # Log business in manually
        @business.deliver_welcome!
        redirect_to account_url
    else
        render :action => :new
    end
  end
end
