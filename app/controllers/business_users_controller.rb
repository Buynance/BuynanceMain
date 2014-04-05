class BusinessUsersController < ApplicationController
	
 def recover
    @business = Business.new
  end

  def recovery_instructions

  end

  def recover_account
    @business = Business.find_by email: business_params[:email]
    if !@business.nil?
      @business.deliver_recovery_email!
      redirect_to :recovery_instructions
    else
      flash[:alert] = "Sorry the email you provided does not exist in our system."
      redirect_to :recover
    end
  end

  def password
    if params.has_key?("recovery_code")
      @business = Business.find_by recovery_code: params[:recovery_code]
    else
      redirect_to :root
    end
  end

  def reset_password
    @business = Business.find_by recovery_code: business_params[:recovery_code]
    @business.current_step = :recover_password
    @business.password = business_params[:password]
    @business.password_confirmation = business_params[:password_confirmation]
    if @business.save
      redirect_to :root
    else
      redirect_to :password
    end 
  end

  
end
