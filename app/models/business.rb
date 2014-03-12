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
  has_many :offers
  
  validates :earned_one_month_ago, :earned_two_months_ago, :earned_three_months_ago, :email, presence: true
  #validates :something,  :presence => true, :if => :passed_step_one?
  #validates :something,  :presence => true, :if => :passed_step_one?
  
  #Step One
  validates_numericality_of :earned_one_month_ago, :message => "The amount your business earned a month ago should be a number"
  validates_numericality_of :earned_two_months_ago, :message => "The amount your business earned a month ago should be a number"
  validates_numericality_of :earned_three_months_ago, :message => "The amount your business earned a month ago should be a number"
  validates_acceptance_of :terms_of_service

  #validates :approximate_credit_score, :numericality => { :greater_than => 300, :less_than_or_equal_to => 850 }, message: "Your credit score must fall in the range of 300 to 850" 
  #validates_numericality_of :total_previous_payback_amount, :message => "Your total payback amount should be anumber should be a number"
  #validates_numericality_of :total_previous_payback_balance, :message => "The amount you have to pack back should be a number"
  #validates_format_of :zip_code, :with => /^\d{5}(-\d{4})?$/, :message => "should be in the form 12345 or 12345-6789"

  before_create :init



  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_authentic do |c|
    c.login_field = 'email'
  end # block optional

  def is_averaged_over_minimum
    minimum = 15000
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
    return true if !is_payback_amount_set || is_previous_funding_atleast(0.6) 
    return false
  end

  private

    def init 
      #self.total_previous_payback_balance = 0
      #self.total_previous_payback_amount = 0
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

    def are_defined?(hash)
      return_val = true
      hash.each do |var|
        return_val = (defined?(var)).nil?
      end
      return_val
    end

    def passed_step_one
      are_defined?(self.earned_one_month_ago, self.earned_two_months_ago, self.earned_three_months_ago, self.email, self.presence)
    end
  
end
