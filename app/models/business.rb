'securerandom'
require 'twilio_lib'
require 'decision_logic'

class Business < ActiveRecord::Base

  before_save :parse_phone_number
  #before_save :parse_date
  
  include BusinessValidations
  attr_accessor :current_step, :is_closing_fee, :terms_of_service, :previous_loan_date_visible, :disclaimer
  obfuscate_id :spin => 89238723
  #has_many :offers, :dependent => :destroy
  has_one :business_user, :dependent => :destroy
  has_one :bank_account, :dependent => :destroy
  has_one :routing_number, :dependent => :destroy
  has_many :leads, :dependent => :destroy

  belongs_to :business_type, inverse_of: :businesses

  FUNDING_TYPES = {refinance: 1, funding: 0}

  scope :awaiting_persona_information, where(state: "awaiting_personal_information")
  scope :awaiting_bank_information, where(state: "awaiting_bank_information")
  scope :awaiting_email_confirmation, where(state: "awaiting_email_confirmation")
  scope :awaiting_mobile_confirmation, where(state: "awaiting_mobile_confirmation")
  scope :awaiting_offer_acceptance, where(state: "awaiting_offer_acceptance")
  scope :awaiting_offer_completetion, where(state: "awaiting_offer_completetion")
  scope :awaiting_reenter_market, where(state: "awaiting_reenter_market")
  scope :awaiting_bank_information_refresh, where(state: "awaiting_bank_information_refresh")

  state_machine :state, :initial => :awaiting_personal_information do
   
    event :personal_information_provided do
      transition [:awaiting_personal_information] => :awaiting_bank_information
    end

    # Business activate account is dependant on awaiting email confirmation
    event :bank_information_provided do
      transition [:awaiting_personal_information , :awaiting_bank_information] => :awaiting_email_confirmation
    end

    event :email_confirmation_provided do 
      transition [:awaiting_email_confirmation] => :awaiting_mobile_confirmation
    end

    event :mobile_confirmation_provided_phone do
      transition [:awaiting_mobile_confirmation] => :awaiting_offer_acceptance
    end

    event :mobile_confirmation_provided do
      transition [:awaiting_mobile_confirmation] => :awaiting_offer_acceptance
    end

    event :disclaimer_acceptance_provided do
      transition [:awaiting_disclaimer_acceptance] => :awaiting_offer_acceptance
    end

    event :offer_accepted do
      transition [:awaiting_offer_acceptance] => :awaiting_offer_completetion
    end
   
    event :offer_funded do
      transition [:awaiting_offer_completetion] => :awaiting_requalification
    end

    event :offer_rejected do
      transition [:awaiting_offer_completetion, :awaiting_offer_acceptance] => :awaiting_offer_acceptance
    end

    event :requalified do
      transition [:awaiting_requalification] => :awaiting_bank_information_refresh
    end

    event :bank_information_refreshed do
      transition [:awaiting_bank_information_refresh] => :awaiting_offer_acceptance
    end


  end

  state_machine :qualification_state, :initial => :awaiting_qualification_information do
    event :qualify_for_refi do
      transition [:awaiting_qualification_information] => :qualified_for_refi
    end

    event :disqualify_for_refi do
      transition [:awaiting_qualification_information] => :disqualified_for_refi
    end

    event :qualify_for_funder do
      transition [:awaiting_qualification_information] => :qualified_for_funder
    end

    event :qualify_for_market do
      transition [:awaiting_qualification_information] => :qualified_for_market
    end

    event :disqualify_for_refi do
      transition [:awaiting_qualification_information] => :disqualified_for_refi
    end
    
    event :disqualify do
      transition [:awaiting_qualification_information] => :disqualified_for_funder
    end

  end
  
  LOAN_REASON = ["Invest In Marketing","Pay Old Bills", "Expansion", "Payroll", "Invest In Inventory", "Capital Improvement", "Pay Rent / Mortgage"]
  CREDIT_SCORE_RANGES = ["0", "450-500", "501-550", "551-600", "601-650", "651-700", "701-750", "751-800"]
  DEAL_TYPE_ARRAY = ["Money Collected from Credit Card", "Money Collected from Bank Account"]
  INVALID_LOAN_REASONS = [6]

  STATUS_AWAITING_ACTIVATION = 1
  STATUS_EMAIL_CONFIRMED = 2
  STATUS_NOT_QUALIFIED = 3

  has_many :offers
  has_many :business_users

  before_create :init


  # --------------------------------------------------#
  # Method Approximate credit score string from range #
  # --------------------------------------------------#

  def self.credit_score_string(variable)
    return CREDIT_SCORE_RANGES[variable]
  end

  def create_request_code
    service_key = Buynance::Application.config.service_key
    profile_guid = Buynance::Application.config.profile_guid
    site_user_guid = Buynance::Application.config.site_user_guid 
    customer_id = self.email
    #DecisionLogic.get("https://www.decisionlogic.com/CreateRequestCode.aspx?serviceKey=QBZKMWHRHND5&profileGuid=9538c1e4-2a44-4eca-9587-e5d5bd1fcf65&siteUserGuid=76246387-0c72-401a-b629-b5b102859bb3&customerId=&firstName=#{@business.owner_first_name}&lastName=#{@business.owner_last_name}&routingNumber=#{@business.bank_account.routing_number}&accountNumber=#{@business.bank_account.account_number}") 
    self.initial_request_code = DecisionLogic.get("https://www.decisionlogic.com/CreateRequestCode.aspx?serviceKey=#{service_key}&profileGuid=#{profile_guid}&siteUserGuid=#{site_user_guid}&customerId=#{customer_id}&firstName=#{self.owner_first_name}&lastName=#{self.owner_last_name}&accountNumber=#{self.bank_account.account_number}&routingNumber=#{self.bank_account.routing_number}")
    is_valid = false
    is_valid = true if self.initial_request_code.length <= 10
    return is_valid
  end

  def get_profile
    profile_hash = Hash.new(email: self.business_user.email, business_name: self.name, owners_first_name: self.owner_first_name, 
    owners_last_name: self.owner_last_name, landline_number: self.phone_number, mobile_number: self.mobile_number,
    street_address_1: self.street_address_one, street_address_2: self.street_address_two, city: self.city, 
    state: self.location_state, zip_code: self.zip_code, credit_score_range: CREDIT_SCORE_RANGES[self.approximate_credit_score_range],
    business_type: BusinessType.find(self.business_type_id), loan_reason: LOAN_REASON[self.loan_reason_id],
    bank_account: [account_number: self.bank_account.account_number, routing_number: self.bank_account.routing_number,
      bank_name: self.bank_account.institution_name, avergae_balance: self.bank_account.average_balance, as_of_date: self.bank_account.as_of_date,
      total_credit_transactions: self.bank_account.total_credit_transactions, total_debit_transactions: self.bank_account.total_debit_transactions,
      available_balance: self.bank_account.available_balance, total_negative_days: self.bank_account.total_negative_days, 
      days_of_transaction: self.bank_account.days_of_transaction, total_deposits: self.bank_account.total_number_of_deposits,
      total_deposits_value: self.bank_account.total_deposits_value, transactions_from_date: self.bank_account.transactions_from_date, 
      transactions_to_date: self.bank_account.transactions_to_date])
  end

  # --------------------------------------------------#
  # Method Loan Reason string from id                 #
  # --------------------------------------------------#

  # --------------------------------------------------#
  # Business type string from id                      #
  # --------------------------------------------------#


  def send_mobile_confirmation!
    TwilioLib.send_activation_code(self.mobile_number, self.mobile_opt_code)
  end
  handle_asynchronously :send_mobile_confirmation
  
  def send_mobile_information!
    TwilioLib.send_text(self.mobile_number, "Your 100% FREE Buynance Number Is: #{GlobalPhone.parse(self.routing_number.phone_number).national_format}.  It keeps solicitors from spamming your cell phone!  See e-mail for usage info. Have a successful day!")
  end
  handle_asynchronously :send_mobile_information!

  def deliver_qualified_signup!
    AdminMailer.qualified_signup(self.id).deliver!
  end
  handle_asynchronously :deliver_qualified_signup!

  def deliver_qualified_signup2!
    BusinessMailer.qualified_signup(self).deliver!
  end
  
  def deliver_offer_email!
    AdminMailer.delay.offer_notification(self)
  end
  handle_asynchronously :deliver_offer_email!

  def deliver_activation_instructions!
    reset_perishable_token!
    BusinessMailer.email_registration(self).deliver!
  end
  handle_asynchronously :deliver_activation_instructions!

  def deliver_welcome!
    reset_perishable_token!
    BusinessMailer.welcome(self).deliver!
  end
  handle_asynchronously :deliver_welcome!

  def deliver_average_email!
    BusinessMailer.average_less_than(self).deliver!
  end
  handle_asynchronously :deliver_average_email!
  
  def setup_mobile_routing
    self.mobile_confirmation_provided_phone
    self.twimlet_url = TwilioLib.generate_twimlet_url(self.mobile_number)
    routing_number = RoutingNumber.create(success_url: twimlet_url, business_id: self.id, call_count: 0)
    routed_number = TwilioLib.create_phone_number(self.mobile_number, self.location_state, self.twimlet_url, routing_number.id)
    routing_number.phone_number = routed_number
    routing_number.save
    self.send_mobile_information! 
  end



  def is_qualified_for_funder(amount, days)
    return ((self.years_in_business >= 1) and (self.approximate_credit_score_range >= 3) and self.bank_account.is_average_deposit_atleast(amount) and (self.bank_account.days_of_transactions >= days))
  end
  
  def disqualify!
    self.state = "awaiting_offer_acceptance"
    self.qualification_state = "disqualified_for_funder"
  end

  def qualify
    unless self.qualified_for_funder? or self.qualified_for_refi? or self.qualified_for_market? 
      if true
        if Buynance::Application.config.market_everyone == true
          is_qualified = true
          self.qualify_for_market
        else
          is_qualified = false
          if self.is_refinance
            if is_qualified_for_funder(15000, 6)
              p "qualify"
              is_qualified = true
              self.qualify_for_market
            else
              self.disqualify
            end
          else
            if is_qualified_for_funder(15000, 6)
              p "qualify"
              is_qualified = true
              self.qualify_for_market
            end
          end
        end
      else
        is_qualified = false
        if self.is_refinance
          if has_paid_enough
            is_qualified = true
            self.qualify_for_refi
          else
            self.qualify_for_market
          end
        else
          if is_qualified_for_funder(15000, 6)
            is_qualified = true
            self.qualify_for_funder
          else
            is_qualified = true
            self.qualify_for_market
          end
        end
      end
    else
      return true
    end
    return is_qualified
  end

  def is_averaged_over_minimum
    minimum = 15000
    return true if get_average_last_three_months_earnings >= minimum
    return false
  end
  
  def has_paid_enough
    return true if !is_payback_amount_set || is_previous_funding_atleast(0.5) 
    return false
  end

  def activate(code)
    if code == self.activation_code
      self.is_email_confirmed = true
      return true
    else
      return false
    end
  end

  def qualified?
    return false if !self.is_averaged_over_minimum
    return false if !self.loan_reason_id.nil? and INVALID_LOAN_REASONS.include?(self.loan_reason_id)


    return false if !self.approximate_credit_score_range.nil? and self.approximate_credit_score_range == 1
    return false if !self.approximate_credit_score_range.nil? and self.best_possible_offer < 5000
    return false if !self.is_tax_lien.nil? and self.is_tax_lien and !self.is_payment_plan
    return false if !self.is_judgement.nil? and self.is_judgement
    return false if !self.is_ever_bankruptcy.nil? and self.is_ever_bankruptcy
    return false if !self.years_in_business.nil? and self.years_in_business == 0
    return false if !self.amount_negative_balance_past_month.nil? and self.amount_negative_balance_past_month >= 3
    return false if !self.business_type_id.nil? and (BusinessType.find(business_type_id).is_rejecting)

    return false if !self.has_paid_enough

    return true
  end


  def update_step(step)
    if step == :personal
      self.update_account_information
      return true
    elsif step == :financial
      if !self.is_paying_back
        if self.qualified?
          self.update_account_information
          return true
        else
          self.decline
        end 
      end
    elsif step == :funders
      if self.has_paid_enough
        self.update_account_information
        return true
      else
        self.decline
      end
    end
    return false
  end

  def create_offers(amount)
    average = Offer.get_three_months_average(self.earned_one_month_ago,
        earned_two_months_ago, earned_three_months_ago)
    days = Offer.get_days(self.approximate_credit_score_range) 
    counter = 0 
    offers_added = 0
    for n in 0...amount 
      if counter < 100 
        if offers_added != 2
          factor_rate = Offer.get_random_rate(1.35, 1.48)
          factor_rate = Offer.get_random_rate(1.30, 1.38) if self.approximate_credit_score_range >= 4  
          daily_rate = Offer.get_random_rate(0.13, 0.15)
          daily_payback = Offer.get_daily_payback(self.average_daily_balance_bank_account, daily_rate)
          total_payback = daily_payback * days
          offer = (total_payback / factor_rate).round(-2)

          total_payback = offer * factor_rate
          daily_payback = total_payback / days

          if(offer > (average * 0.35))
            percent_monthly = Offer.get_random_rate(0.33, 0.35)
            offer = (average * percent_monthly).round(-2)
            total_payback = offer * factor_rate
            daily_payback = total_payback / days
          end

          if offer < 5000
            n = n-1
          else
            offers << Offer.create(cash_advance_amount: offer, daily_merchant_cash_advance: daily_payback,
            days_to_collect: days, total_payback_amount: total_payback, factor_rate: factor_rate, is_best_offer: false, is_active: true)
            offers_added = offers_added + 1
          end
            counter = counter + 1;
        else
          offer = self.best_possible_offer
          factor_rate =  Offer.get_random_rate(1.30, 1.31)
          total_payback = offer * factor_rate
          daily_payback = total_payback / days
          if(offer > (average * 0.40))
            percent_monthly = Offer.get_random_rate(0.39, 0.40)
            offer = (average * percent_monthly).round(-2)
            total_payback = offer * factor_rate
            daily_payback = total_payback / days
          end
          offers << Offer.create(cash_advance_amount: offer, daily_merchant_cash_advance: daily_payback,
            days_to_collect: days, total_payback_amount: total_payback, factor_rate: factor_rate, is_timed: true, is_best_offer: true, is_active: true)
          offers_added = offers_added + 1
          counter = counter + 1
        end
      end
    end
  end

  def main_offer
    return Offer.find(self.main_offer_id)
  end
  
  def best_possible_offer
      days = Offer.get_days(self.approximate_credit_score_range)
      rate = 1.35
      rate = 1.30 if days >= 120
      best =  Offer.get_best_possible_offer(self.average_daily_balance_bank_account, days, rate)
      return best
  end

  def accept_as_lead
    self.deliver_activation_instructions!
    Lead.create(business_id: self.id)
    self.bank_information_provided
  end

  def get_credit_score_label(number)
    return CREDIT_SCORE_RANGES[number]
  end
  
  def get_deal_type_label(number)
    return DEAL_TYPE_ARRAY[number]
  end

  private

    def parse_phone_number
      if self.current_step == :personal
        phone_number_object = GlobalPhone.parse(self.phone_number)
        mobile_number_object = GlobalPhone.parse(self.mobile_number)
        phone_number_object = nil if (phone_number_object != nil and phone_number_object.territory.name != "US")
        mobile_number_object = nil if (mobile_number_object != nil and mobile_number_object.territory.name != "US")
        if phone_number_object.nil?
          self.phone_number = nil
        else
          self.phone_number = phone_number_object.international_string
        end
        if mobile_number_object.nil?
          self.mobile_number = nil
        else
          self.mobile_number = mobile_number_object.international_string      
        end
      end
    end

    def parse_date
      if self.current_step == :refinance
        date_array = self.previous_loan_date.split('-')
        self.previous_loan_date = nil
        if date_array.length == 3
          if date_array[0].to_i <= 12
            if date_array[1].to_i <= 31
              if date_array[2].to_i <= 3000
                new_date = Date.new(date_array[2],date_array[1],date_array[0])
                if new_date.is_valid? and new_date <= Date.today
                  self.previous_loan_date = new_date
                end
              end
            end  
          end
        end
      end
    end

    def init 
      self.is_paying_back = false if self.is_paying_back.nil?
      self.activation_code = Business.generate_activation_code
      self.recovery_code = Business.generate_activation_code
      self.confirmation_code = Business.generate_activation_code
      self.mobile_opt_code = Business.generate_mobile_opt_code
    end

    def get_average_last_three_months_earnings
      (self.earned_one_month_ago + self.earned_two_months_ago + self.earned_three_months_ago) / 3
    end

    def is_previous_funding_atleast(decimal_percent)
      return true if   (1-(self.total_previous_payback_balance.to_f / self.total_previous_payback_amount)) > decimal_percent
      return false
    end

    def is_payback_amount_set
      return false if self.total_previous_payback_balance.nil? || self.total_previous_payback_amount.nil?
      return true
    end

    def self.generate_activation_code
      return SecureRandom.hex
    end

    def self.generate_mobile_opt_code
      virgin_code = SecureRandom.urlsafe_base64(24, false)
      regular_code = virgin_code.downcase.gsub(/[-_]/,'')[0,8]
      return regular_code
    end
end
