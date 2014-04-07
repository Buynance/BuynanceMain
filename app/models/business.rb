require 'securerandom'

class Business < ActiveRecord::Base
  
  include BusinessValidations
  attr_accessor :current_step
  obfuscate_id :spin => 89238723
  
  LOAN_REASON = ["Invest In Marketing","Pay Old Bills", "Expansion", "Payroll", "Invest In Inventory", "Capital Improvement", "Pay Rent / Mortgage"]
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

  # --------------------------------------------------#
  # Method Loan Reason string from id                 #
  # --------------------------------------------------#

  # --------------------------------------------------#
  # Business type string from id                      #
  # --------------------------------------------------#

  
  
  def deliver_qualified_signup!
    AdminMailer.delay.qualified_signup(self)
  end

  def deliver_offer_email!
    AdminMailer.delay.offer_notification(self)
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
    if step == :financial
      if !self.is_paying_back and self.qualified?
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
            days_to_collect: days, total_payback_amount: total_payback, factor_rate: factor_rate)
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
            days_to_collect: days, total_payback_amount: total_payback, factor_rate: factor_rate, is_timed: true)
          offers_added = offers_added + 1
          counter = counter + 1
        end
      end
    end
  end

  def main_offer
    return Offer.find(main_offer_id)
  end
  
  def best_possible_offer
      days = Offer.get_days(self.approximate_credit_score_range)
      rate = 1.35
      rate = 1.30 if days >= 120
      best =  Offer.get_best_possible_offer(self.average_daily_balance_bank_account, days, rate)
      return best
  end
  

  private

    def init 
      self.is_paying_back = false if self.is_paying_back.nil?
      self.activation_code = Business.generate_activation_code
      self.recovery_code = Business.generate_activation_code
      self.confirmation_code = Business.generate_activation_code
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


end
