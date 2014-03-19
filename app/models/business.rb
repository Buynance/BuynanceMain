require 'securerandom'

######## Validations ###############

  # name -> atleast three characters long
  # email -> email validator ->
  # password -> password validator atleast 5 characters long, must contain a combination of chracters and numbers
  # owner_first_name -> must only contain characters, atleast two characters long
  # owner_last_name -> must only contain characters, atleast two characters long
  # phone_number -> Global phone
  # city ->
  # state ->
  # zip_code ->
  # total_previous_payback_amount ->
  # total_previous_payback_balance ->
  # approximate_credit_score ->

class Business < ActiveRecord::Base
  
  include BusinessValidations
  attr_accessor :current_step
  
  obfuscate_id :spin => 89238723
  has_many :offers

  before_create :init

  acts_as_authentic do |c|
    c.login_field = 'email'
    c.merge_validates_format_of_email_field_options :message => 'Please include a valid email address.'
    c.merge_validates_confirmation_of_password_field_options :message => "Password confirmation should match the password."
    c.merge_validates_length_of_password_confirmation_field_options :message => "Password too short (atleast 6 characters)."
    c.merge_validates_uniqueness_of_email_field_options :message => "Email already taken, please select another email. "
  end # block optional
  
  # ------------------------------------------#
  # Scope Approximate credit score from range #
  # ------------------------------------------#

  def deliver_qualified_signup!
    AdminMailer.delay.qualified_signup(self)
  end

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

  def is_averaged_over_minimum
    minimum = 15000
    return true if get_average_last_three_months_earnings >= minimum
    return false
  end
  
  def has_paid_enough
    return true if !is_payback_amount_set || is_previous_funding_atleast(0.6) 
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

  def is_qualified
    return false if !self.is_averaged_over_minimum
    return false if !self.is_tax_lien.nil? and self.is_tax_lien and !self.is_paying_back
    return false if !self.is_ever_bankruptcy.nil? and self.is_ever_bankruptcy
    return false if !self.approximate_credit_score_range.nil? and self.approximate_credit_score_range == 1
    return false if !self.amount_negative_balance_past_month.nil? and self.amount_negative_balance_past_month >= 3
    return false if !self.has_paid_enough
    return true
  end

  def update_step(step)
    if step == :financial
      if !self.is_paying_back and self.is_qualified
        self.is_finished_application = true
        return true 
      end
    elsif step == :funders
      self.is_finished_application = true
      return true if self.has_paid_enough
    else
      return false
    end
  end

  def create_random_offers(min, max)
    amount = rand(max - min + 1) + min
    for n in 0..amount
      factor_rate = rand * (1.32 - 1.30) + 1.30
      cash_advance_amount = Offer.get_advance_amount(self.earned_one_month_ago,
        earned_two_months_ago, earned_three_months_ago, 0.32, 0.37).round(-2)
      payback_amount = cash_advance_amount * factor_rate
      period = Offer.get_random_months(4, 12)
      days = period * 30
      pay_per_day = payback_amount / days
      maximum_pay_per_day = @business.average_daily_balance_bank_account * 0.15
      if (pay_per_day > maximum_pay_per_day)
        pay_per_day = maximum_pay_per_day
        payback_amount = pay_per_day * days
        cash_advance_amount = payback_amount / factor_rate
      end
      offers << Offer.create(cash_advance_amount: cash_advance_amount, daily_merchant_cash_advance: pay_per_day,
        months_to_collect: period, days_to_collect: days, total_payback_amount: payback_amount)
    end
  end
  
  private

    def init 
      self.is_paying_back = false if self.is_paying_back.nil?
      self.activation_code = generate_activation_code
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

    def generate_activation_code
      return SecureRandom.hex
    end
  
end
