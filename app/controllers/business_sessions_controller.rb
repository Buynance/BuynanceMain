class BusinessSessionsController < ApplicationController
  before_filter :require_business, :only => :destroy
  before_filter :require_no_business, :only => [:new, :create]

  def new
    @business_session = BusinessSession.new
  end

  def create
    @business_session = BusinessSession.new(params[:business_session])
    if @business_session.save
      flash[:notice] = "Login successful!"
      if (current_business.is_finished_application)
        if(!current_business.is_email_confirmed)
          flash[:notice] = "Please Activate Your Account"
        end
        redirect_back_or_default account_url(current_business)
      else
        redirect_to new_business_path
      end   
    else
      flash[:notice] = "Login Fail"
      render :action => :new
    end
  end

  def destroy
    current_business_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_business_session_url
  end
end