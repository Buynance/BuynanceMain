require 'securerandom'

class Business < ActiveRecord::Base
  has_many :offers
  validates :earned_one_month_ago, :earned_two_months_ago, :earned_three_months_ago, :email, presence: true
  before_create :init
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_authentic do |c|
    c.login_field = 'email'
  end # block optional

  def get_average_last_three_months_earnings
    (self.earned_one_month_ago + self.earned_two_months_ago + self.earned_three_months_ago) / 3
  end

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

  def init 
    self.is_paying_back = false if self.is_paying_back.nil?
    self.activation_code = generate_activation_code
  end

  def generate_activation_code
    return SecureRandom.hex
  end
end
