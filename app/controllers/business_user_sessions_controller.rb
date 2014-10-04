class BusinessUserSessionsController < ApplicationController
  before_filter :require_business_user, :only => :destroy
  before_filter :require_no_business_user, :only => [:new, :create]

  def new
    @business_user_session = BusinessUserSession.new
  end

  def create
    @business_user_session = BusinessUserSession.new(params[:business_user_session])
    if @business_user_session.save
      current_business_user = BusinessUser.find(@business_user_session.record.id)
      current_business = Business.find(current_business_user.business_id)
      if (current_business.is_finished_application)
        if(!current_business.is_email_confirmed)
        end
        redirect_back_or_default account_url(current_business)
      else
        redirect_to new_business_path
      end   
    else
      render :action => :new
    end
  end

  def destroy
    current_business_user_session.destroy
    redirect_back_or_default new_business_user_session_url
  end
end