class BusinessesController < ApplicationController
  before_filter :require_business, :only => [:show, :edit, :update, :activate_account, :activate]
  before_filter :require_no_business, :only => [:new, :create]
  before_filter :standardize_params, :only => [:create]

  def new 
      @business = Business.new     
  end

  def create
    @business = Business.new(business_params)
    @business.current_step = :new
    if @business.save
      if @business.qualified?
        session[:business_id] = @business.id
        redirect_to business_steps_path
      else
        redirect_to business_path(@business.id)
      end
    else
      render :action => :new
    end
  end

  def show
    @business = current_business
    if !@business.is_email_confirmed
      if !@business.qualified?
        render :action => :not_qualified
      elsif !@business.is_finished_application
        redirect_to business_steps_path
      else
        redirect_to :action => :activate_account
      end
    end
  end

  def edit
    @business = current_business
  end

  def update
    @business = current_business # makes our views "cleaner" and more consistent
    if @business.update_attributes(business_params)
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  def insert
    @business = current_business
    @business.main_offer_id = params[:id]
    @business.save
    if Rails.env.production?
      @business.deliver_offer_email!
    end
  end

  def confirm_account
    @business = Business.find(params[:business_id])
    if @business.confirmation_code != params[:confirmation_code]
      redirect_to :root_path
    end
  end

  def confirm
    @business = Business.find(params[:business_id])
    if !is_email_confirmed && @business.update_attributes(business_params)
      @business.is_email_confirmed = true
      @business.save
      redirect_to business_path(@business.id)
    end
  end

  def recover
    @business = Business.find(params[:business_id])
    if !is_email_confirmed && @business.update_attributes(business_params)
      @business.is_email_confirmed = true
      @business.recovery_code = Business.generate_activation_code
      @business.save
      redirect_to business_path(@business.id)
    end
  end

  def recover_account
    @business = Business.find(params[:business_id])
    if @business.confirmation_code != params[:activation_code]
      redirect_to :root_path
    end
  end

  def activate_account
    @business = current_business
  end

  def not_qualified
    @business = current_business
  end

  def activate
    @business = current_business
    puts "===================#{params[:activation_code]}"
    @business.save if @business.activate(params[:activation_code])
    redirect_to :action => :show
  end

  private

    def standardize_params
      params[:business][:earned_one_month_ago].gsub!( /[^\d.]/, '').slice!(".00")
      params[:business][:earned_two_months_ago].gsub!( /[^\d.]/, '').slice!(".00")
      params[:business][:earned_three_months_ago].gsub!( /[^\d.]/, '').slice!(".00")
    end

    def business_params
      return params.require(:business).permit(:earned_one_month_ago, 
        :earned_two_months_ago, :earned_three_months_ago, :email, 
        :password, :password_confirmation, :terms_of_service, :activation_code, :loan_reason_id, :is_accept_offer_disclaimer) 
    end
  
end
