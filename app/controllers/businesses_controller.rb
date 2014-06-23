require 'decision_logic.rb'

class BusinessesController < ApplicationController
  before_filter :require_business_user, :only => [:show, :accept_offer, :activate_account, :activate]
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
    if @business.awaiting_personal_information?
      redirect_to funding_steps_path
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
    @business.comfirm_account
    @business.save if @business.activate(params[:activation_code])
    redirect_to :action => :show
  end

  def show_offers
    @business = current_business
    @offers = @business.leads.last.offers
  end

  def error
    
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

