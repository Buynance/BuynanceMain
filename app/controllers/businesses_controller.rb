require 'decision_logic.rb'
require 'twilio_lib'

class BusinessesController < ApplicationController
  before_filter :require_business_user, :only => [:show, :accept_offer, :activate_account, :activate, :comfirm_account, :comfirm_mobile]
  before_filter :require_no_business_user, :only => [:new, :create]
  before_filter :grab_business_and_business_user, :only => [:show]
  #before_filter :standardize_params, :only => [:create]

  def new 
      @business_user = BusinessUser.new 
      @business = Business.new   
      @business.is_refinance = false
      @business.is_refinance = true if params[:is_refinance] == "true"

  end

  def create

    @business_user = BusinessUser.new(business_user_params)
    @business = Business.new(business_params)
    if @business_user.valid? && @business.valid?
      @business_user.save
      @business.save
      @business_user.update_attribute(:business_id, @business.id)
      @business.update_attribute(:main_business_user_id, @business_user.id)
      @business.update_attribute(:email, @business_user.email)
      redirect_to funding_steps_path
    else
      render :action => :new
    end
  end

  def show 
    #if @business.declined?
    #  render :action => :not_qualified
    if @business.awaiting_personal_information? or @business.awaiting_bank_information?
      redirect_to funding_steps_path
    elsif @business.awaiting_email_confirmation?
      redirect_to controller: 'static_pages', action: 'confirm_email'
    elsif @business.awaiting_mobile_confirmation?
      redirect_to action: 'confirm_account'
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
    @business = current_business
    if @business.activate(params[:activation_code])
      @business.email_confirmation_provided
      @business.send_mobile_confirmation!
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
    @business = current_business
  end

  def confirm_mobile
    business = current_business
    if business.mobile_opt_code == params[:mobile][:mobile_opt_code]
      business.mobile_confirmation_provided
      business.setup_mobile_routing
      business.save
      redirect_to action: :show
    else
      flash[:alert] = "Mobile code is incorrect. Please try again."
      render :confirm_account
    end
  end

  def twiml
    business = Business.find(params[:id], no_obfuscated_id: true)
    twiml = ""
    twiml = TwilioLib.generate_voice_xml(business.mobile_number) unless business.nil?
    
    render xml: twiml
  end

  private


    def business_user_params
      return params.require(:business_user).permit(:email, 
        :password, :password_confirmation) 
    end

    def business_params
      return params.require(:business).permit(:terms_of_service, :recovery_code, :name, :is_refinance) 
    end
end

