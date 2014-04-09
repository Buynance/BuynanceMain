class BusinessesController < ApplicationController
  before_filter :require_business_user, :only => [:show, :accept_offer, :activate_account, :activate]
  before_filter :require_no_business_user, :only => [:new, :create]
  before_filter :grab_business_and_business_user, :only => [:show]
  before_filter :standardize_params, :only => [:create]

  def new 
      @business_user = BusinessUser.new 
      @business = Business.new    
  end

  def create
    @business_user = BusinessUser.new(business_user_params)
    @business = Business.new(business_params)
    if @business_user.save && @business.save
      @business_user.update_attribute(:business_id, @business.id)
      @business.update_attribute(:main_business_user_id, @business_user.id)
      @business.update_attribute(:email, @business_user.email)
      if @business.qualified?
        session[:business_user_id] = @business_user.id
        redirect_to business_steps_path
      else
        @business.decline
        redirect_to action: :show
      end
    else
      render :action => :new
    end
  end

  def show 
    if @business.declined?
      render :action => :not_qualified
    elsif @business.awaiting_information?
      redirect_to business_steps_path
    elsif@business.awaiting_confirmation?
      render :action => :activate_account
    end
    #if !@business.is_email_confirmed
    #  if !@business.qualified?
    #    render :action => :not_qualified
    #  elsif !@business.is_finished_application
    #    redirect_to business_steps_path
    #  else
    #    render :action => :activate_account
    #  end
    #end 
    
  end

  def accept_offer
    current_business.update_attribute(:main_offer_id, params[:id])
    current_business.accept_offer
    redirect_to after_offer_path(:personal)
  end

  def activate_account
    @business = current_business
  end

  def not_qualified
    @business = current_business
  end

  def activate
    @business = current_business
    @business.comfirm_account
    @business.save if @business.activate(params[:activation_code])
    redirect_to :action => :show
  end

  private

    def standardize_params
      params[:business][:earned_one_month_ago].gsub!( /[^\d.]/, '').slice!(".00")
      params[:business][:earned_two_months_ago].gsub!( /[^\d.]/, '').slice!(".00")
      params[:business][:earned_three_months_ago].gsub!( /[^\d.]/, '').slice!(".00")
    end

    def business_user_params
      return params.require(:business_user).permit(:email, 
        :password, :password_confirmation, :activation_code) 
    end

    def business_params
      return params.require(:business).permit(:earned_one_month_ago, 
        :earned_two_months_ago, :earned_three_months_ago, :loan_reason_id, :terms_of_service, :recovery_code) 
    end

    def set_offer_time
      created_time = @business.created_at
      current_time = DateTime.now
      diff = created_time - current_time
      @hours = 24 - (diff / 3600).abs.ceil
      @minutes = "#{((diff % 3600) / 60).floor}"
      @seconds = "#{((diff % 3600) % 60).floor + 1}"
      @minutes = "" if @minutes.to_i == 0 and @hours.to_i >= 1
      @minutes = "0#{@minutes}" if @minutes.length == 1
      @seconds = "0#{@seconds}" if @seconds.length == 1
    end
end

