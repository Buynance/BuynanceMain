require 'decision_logic.rb'
require 'twilio_lib'

class BusinessesController < ApplicationController
  before_filter :require_business_user, :only => [:show, :accept_offer, :activate_account, :confirm_account, :confirm_mobile, :qualified_funder, :qualified_market, :disqualified]
  before_filter :require_no_business_user, :only => [:new, :create]
  before_filter :grab_business_and_business_user, :only => [:show]
  before_filter :send_production_js, only: [:new, :qualified_funder, :qualified_market, :disqualified]
  #before_filter :standardize_params, :only => [:create]


  def new 
      @business_user = BusinessUser.new 
      @business = Business.new   
  end

  def create
    @business = Business.new(business_params)
    @business_user = BusinessUser.new(business_user_params)
    @business.is_refinance = false
    
    if @business_user.valid? && @business.valid?
      @business_user.save
      @business.save
      @business_user.update_attribute(:business_id, @business.id)
      @business.update_attribute(:main_business_user_id, @business_user.id)
      @business.update_attribute(:email, @business_user.email)
      flash[:signup] = true
      redirect_to funding_steps_path
    else
      render :action => :new
    end
  end

  def show 
    #if @business.declined?
    #  render :action => :not_qualified
    if @business.bank_error?
      redirect_to bank_failure_path
    elsif @business.awaiting_personal_information? or @business.awaiting_bank_information?
      redirect_to funding_steps_path
    elsif @business.awaiting_email_confirmation?
      redirect_to controller: 'static_pages', action: 'confirm_email'
    elsif @business.awaiting_mobile_confirmation?
      redirect_to action: 'confirm_account'
    elsif @business.qualified_for_funder?
      render 'qualified_funder'
    elsif @business.qualified_for_refi?
      render 'qualified_refi'
    elsif @business.accepted_market? || @business.accepted_buynance_fast_advance? || @business.accepted_buynance_fast_advance_plus? || @business.accepted_affiliate_advance?
      redirect_to action: 'qualified_market'
    elsif @business.disqualified_for_refi? || @business.disqualified_for_funder?
      redirect_to action: 'disqualified'
    elsif @business.awaiting_offer_acceptance?
      redirect_to display_offers_url
    elsif @business.awaiting_offer_completetion?
      redirect_to controller: 'business_dashboards', action: 'offer_accepted'
    elsif @business.awaiting_reenter_market?
      redirect_to reenter_market_url
    else
      redirect_to action: :error
    end
  end

  def details
    @business = Business.new
  end

  def activate_account 
    @business = current_business
  end

  def not_qualified
    @business = current_business
  end

  def activate
    @business = Business.where("activation_code = ? AND state = ?", params[:activation_code], "awaiting_email_confirmation").last
    
    unless @business.nil?
      @business.email_confirmation_provided
      @business.send_mobile_confirmation!
      flash[:is_email_confirmed] = true
      flash[:success_activation_message] = "Your account has been activated. Please login to continue with your application."
    else
      flash[:faliure_activation_message] = "Your account is already activated or the activation link is invalid."
    end
    redirect_to :action => :show
  end

  def show_offers
    @business = current_business
    @offers = @business.leads.last.offers
  end

  def error
    
  end

  def confirm_account
    pluggable_js(email: current_business.business_user.email, is_production: is_production, is_email_confirmed: (flash[:is_email_confirmed] == true))
    @business = current_business
    @business.passed_email_confirmation
  end

  def confirm_mobile
    business = current_business
    if business.mobile_opt_code == params[:mobile][:mobile_opt_code]
      if business.qualify
        #if business.qualified_for_funder?
        #  business.mobile_confirmation_provided
        #elsif business.qualified_for_refi?
        #  business.mobile_confirmation_provided_phone
        #elsif business.qualified_for_market?
        #  business.mobile_confirmation_provided_phone
        #end
        #unless business.bank_account.nil? or business.bank_account.institution_name.nil?
        #  business.deliver_qualified_signup!
        #end
        business.mobile_confirmation_provided
        #business.setup_mobile_routing if Rails.env.production?
      else
        business.mobile_confirmation_provided
        business.passed_mobile_confirmation
        business.disqualify
      end
      
      redirect_to action: :show
    else
      flash[:alert] = "Mobile code is incorrect. Please try again."
      render :confirm_account
    end
  end

  def twiml
    business = Business.find(params[:id])
    twiml = ""
    twiml = TwilioLib.generate_voice_xml(business.mobile_number) unless business.nil?
    
    render xml: twiml
  end

  def qualified_funder
  end

  def qualified_refi
  end

  def qualified_market
    @business = current_business 
    @business.passed_mobile_confirmation
    @has_offers = @business.offers.size > 2
  end

  def disqualified
  end

  def accept_offer
    @business = current_business 
    offer_type = params[:offer]
    if offer_type == "1"
      @business.accept_buynance_fast_advance
    elsif offer_type == "2"
      @business.accept_buynance_fast_advance_plus
    elsif offer_type == "3"
      @business.accept_affiliate_advance
    end
    redirect_to :action => :show
  end


  private


    def business_user_params
      return params.require(:business_user).permit(:email, 
        :password, :password_confirmation, :email_confirmation) 
    end

    def business_params
      return params.require(:business).permit(:terms_of_service, :recovery_code, :name, :is_refinance, :referral_code, :discovery_type_id) 
    end

    def accept_offer_params
      return params.require(:accept_offer).permit(:offer) 
    end

end

