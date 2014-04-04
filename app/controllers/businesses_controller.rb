class BusinessesController < ApplicationController
  before_filter :require_business, :only => [:show, :activate_account, :activate]
  before_filter :require_no_business, :only => [:new, :create, :recover, :recover_account, :password]
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
    offer = nil
    #@business.offers.each do |i|
    #  if i.is_timed == true
    #    offer = i
    #  end
    #end

    if !@business.is_email_confirmed
      if !@business.qualified?
        render :action => :not_qualified
      elsif !@business.is_finished_application
        redirect_to business_steps_path
      else
        redirect_to :action => :activate_account
      end
    end

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

  def accept_offer
    @business = current_business
    @business.main_offer_id = params[:id]
    @business.save
    redirect_to after_offer_path(:personal)
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
        :password, :password_confirmation, :terms_of_service, :activation_code, :loan_reason_id, :is_accept_offer_disclaimer, :recovery_code) 
    end
  
end
