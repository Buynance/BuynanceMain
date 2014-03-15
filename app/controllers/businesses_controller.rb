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
      if @business.is_averaged_over_minimum
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
      if !@business.is_averaged_over_minimum
        render :action => :not_qualified
      elsif !@business.has_paid_enough
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
        :password, :password_confirmation, :terms_of_service, :activation_code) 
    end
  
end
