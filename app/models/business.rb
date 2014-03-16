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
    c.merge_validates_format_of_email_field_options :message => 'Please include a valid email address'
    c.merge_validates_confirmation_of_password_field_options :message => "Password confirmation should match the password"
    c.merge_validates_length_of_password_confirmation_field_options :message => "Password too short (atleast 6 characters)"
  end # block optional

  def deliver_activation_instructions!
    reset_perishable_token!
    BusinessMailer.email_registration(self).deliver!
    AdminMailer.qualified_signup.deliver!
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

  def update_step(step)
    if step == :financial
      if !self.is_paying_back
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
