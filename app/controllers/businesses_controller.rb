class BusinessesController < ApplicationController
	#before_filter :authenticate_business!

  before_filter :require_business, :only => [:show, :edit, :update, :activate_account]
  before_filter :require_no_business, :only => [:new, :create]

  def new 
    if(require_no_business)
      @business = Business.new
    else
      @business = current_business
      if (@business.is_finished_application)
        flash[:notice] = "You already have an account"
        redirect_to root_path
      else
        redirect_to business_steps_path
        ###
        #if @business.passed_personal_information && @business.is_paying_back
        #  redirect_to business_steps_path(:past_merchants)
        #else 
        #  if @business.passed_recent_earnings
        #    redirect_to business_steps_path(:personal)
        #  end
        #end
        ###
      end
    end
  end

  def create
    @business = Business.new(business_params)
    @business.passed_recent_earnings = true
    
    if @business.save
      if @business.is_averaged_over_minimum
        flash[:notice] = "Your account has been created."
        session[:business_id] = @business.id
        redirect_to business_steps_path
      else
        @business.deliver_average_email!
      end
    else
      flash[:notice] = "There was a problem creating you."
      render :action => :new
    end

  end

  def show
    @business = current_business
    if !@business.is_email_confirmed
      if !@business.is_finished_application
        flash[:notice] = "You need to finish your application before you continue"
        redirect_to new_business_path
      else
        redirect_to activate_account_business_path
      end
    end
  end

  def edit
    @business = current_business
  end

  def update
    @business = current_business # makes our views "cleaner" and more consistent
    if @business.update_attributes(business_params)
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
	
  def activate_account
    @business = current_business

  end

  def business_params
    	params.require(:business).permit(:id, :name, :email, :password, :password_confirmation, :owner_first_name, :owner_last_name, :open_date, :is_authenticated, :is_accepting, :is_accept_credit_cards, :phone_number, :street_address_one, :street_address_two, :city, :state, :zip_code, :is_paying_back, :previous_merchant_id, :total_previous_payback_amount, :total_previous_payback_balance, :is_email_confirmed, :earned_one_month_ago, :earned_two_months_ago, :earned_three_months_ago, :owner_first_name, :owner_last_name, :city, :state, :openid_identifier )
  end

end
