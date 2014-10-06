class BusinessUsersController < ApplicationController
  before_filter :require_no_business_user, :only => [:recover, :recovery_instructions, :recover_account, :password, :reset_password]

  def recover
    @business_user = BusinessUser.new
  end

  def recovery_instructions

  end

  def recover_account
    @business_user = BusinessUser.find_by email: business_user_params[:email]
    if !@business_user.nil?
      @business_user.deliver_recovery_email!
      redirect_to :recovery_instructions_path
    else
      flash[:alert] = "Sorry the email you provided does not exist in our system."
      redirect_to :recovery_path
    end
  end

  def password
    if params.has_key?("recovery_code")
      @business_user = BusinessUser.find_by recovery_code: params[:recovery_code]
    else
      redirect_to :root
    end
  end

  def reset_password
    @business_user = BusinessUser.find_by recovery_code: business_user_params[:recovery_code]
    @business_user.current_step = :recover_password
    @business_user.password = business_user_params[:password]
    if @business_user.save
      redirect_to :root
    else
      redirect_to recovery_password_path(:recovery_code => business_user_params[:recovery_code])
    end 
  end

  private 

    def business_user_params
      return params.require(:business_user).permit(:email, :password, :password_confirmation, :recovery_code) 
    end

  
end
