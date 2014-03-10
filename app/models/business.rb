require 'securerandom'

class Business < ActiveRecord::Base
  has_many :offers
  validates :earned_one_month_ago, :earned_two_months_ago, :earned_three_months_ago, :email, presence: true
  validates_numericality_of :earned_one_month_ago, :message => "The amount your business earned a month ago should be a number"
  validates_numericality_of :earned_two_months_ago, :message => "The amount your business earned a month ago should be a number"
  validates_numericality_of :earned_three_months_ago, :message => "The amount your business earned a month ago should be a number"
  before_create :init
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_authentic do |c|
    c.login_field = 'email'
  end # block optional

  def is_averaged_over_minimum
    minimum = 12000
    return true if get_average_last_three_months_earnings >= minimum
    return false
  end

  def activate!
    self.is_email_confimed = true
    save
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    BusinessMailer.email_registration(self).deliver!
  end

  def deliver_welcome!
    reset_perishable_token!
    BusinessMailer.welcome(self).deliver!
  end

  def deliver_average_email!
    BusinessMailer.average_less_than(self).deliver!
  end

  def has_paid_enough
    return false if !is_payback_amount_set || is_previous_funding_atleast(0.6) 
    return true
  end

  private

    def init 
      self.total_previous_payback_balance = 0
      self.total_previous_payback_amount = 0
      self.is_paying_back = false if self.is_paying_back.nil?
      self.activation_code = generate_activation_code
    end

    def get_average_last_three_months_earnings
      (self.earned_one_month_ago + self.earned_two_months_ago + self.earned_three_months_ago) / 3
    end

    def is_previous_funding_atleast(decimal_percent)
      return true if (self.total_previous_payback_balance / self.total_previous_payback_amount) >= decimal_percent
      return false
    end

    def is_payback_amount_set
      return false if self.total_previous_payback_balance * self.total_previous_payback_amount == 0
      return true
    end

    def generate_activation_code
      return SecureRandom.hex
    end
  
end
