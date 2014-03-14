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
  attr_accessor :current_step

  obfuscate_id :spin => 89238723
  has_many :offers

  # Step One

  validates :earned_one_month_ago,
    presence: {message: "Please include the amount of money earned one month ago"},
    numericality: {only_integer: true, message: "Please make sure the amount you earned one month ago is a number"},
    on: :create

  validates :earned_two_months_ago,
    presence: {message: "Please include the amount of money earned two months ago"}
    numericality: {only_integer: true, message: "Please make sure the amount you earned two month ago is a number"},
    on: :create

  validates :earned_three_months_ago,
    presence: {message: "Please include the amount of money earned three months ago"}
    numericality: {only_integer: true, message: "Please make sure the amount you earned three months ago is a number"},
    on: :create

  validates :password,
    format: {with: /^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/, message: "Your password must be at least 6 characters and include one number and one letter."},
    on: :create

  validates_acceptance_of :terms_of_service, message: "Please accept the terms and conditions"

  #Step Two

  validates :owner_first_name,
    presence: {message: "Please include your first name"},
    if: -> {self.current_step == :personal}

  validates :owner_last_name,
    presence: {message: "Please include your last name"},
    if: -> {self.current_step == :personal}

  validates :name, 
    presence: {message: "Please include your business name"},
    if: -> {self.current_step == :personal}

  validates :phone_number,
    presence: {mesage: "Please include your phone number"}
    length: {minimum: 10, maximum: 10, message: "Your phone number should be 10 digits long"},
    numericality: {only_integer: true, message: "Please include only digits in your phone number"},
    if: -> {self.current_step == :personal}  

  validates :street_address_one,
    presence: {message: "Please include the first line of your address"},
    if: -> {self.current_step == :personal}

  validates :city,
    presence: {message: "Please include your city"},
    if: -> {self.current_step == :personal}

  validates :state,
    presence: {message: "Please include your state"},
    if: -> {self.current_step == :personal}

  validate :zip_code,
    presence: {message: "Please include your five digit zip code"},
    numericality: {only_integer: true, minimum: 5, maximum: 5, message: "Your zip code should only include number and be 5 digits long"},
    if: -> {self.current_step == :personal}

  validate :business_type,
    presence: {message: "Please include your business type"},
    if: -> {self.current_step == :personal}

  # Step 3

  validates :amount_negative_balance_past_month,
    presence: {message: "Please include the amount of days you have been in the negative"},
    numericality: {only_integer: true, minimum: 0, maximum: 30, message: "The amount of days you have been in the negative should be between 0 and 30"},
    if: -> {self.current_step == :financial_information}

  validates :average_daily_balance_bank_account,
    presence: {message: "Please include your bank account average daily balance"},
    numericality: {only_integer: true, message: "Your average daily bank account should be a number"},
    if: -> {self.current_step == :financial_information}

  # Step 4

  validates :total_previous_payback_amount,
    presence: {message: "Please include your total previous payback amount"},
    numericality: {only_integer: true, message: "Your total previous payback amount should be a number"},
    if: -> {self.current_step == :past_merchants}

  validates :total_previous_payback_balance,
    presence: {message: "Please include your total previous payback balance"},
    numericality: {only_integer: true, message: "Your total previous payback balance should be a number"},
    if: -> {self.current_step == :past_merchants}


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
  
  def has_paid_enough
    return true if !is_payback_amount_set || is_previous_funding_atleast(0.6) 
    return false
  end

  def activate(activation_code)
    if activation_code == self.activation_code
      is_email_confimed = true
      return true
    end
    false
  end

  def update_step(step)
    puts "================#{step} going into update"
    if step == :financial_information
      puts "===========financial"
      if !self.is_paying_back
        self.is_finished_application = true
        return true 
      end
    elsif step == :past_merchants
      puts "past merchant"
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
