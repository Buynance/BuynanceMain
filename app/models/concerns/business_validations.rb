module BusinessValidations
  extend ActiveSupport::Concern

  included do
  	# Step - Signup
	validates :earned_one_month_ago,
    presence: {message: "Please include the amount of money your business earned one month ago."},
    numericality: {only_integer: true, message: "Please make sure the amount you earned one month ago is a number."},
    on: :create

	validates :earned_two_months_ago,
    presence: {message: "Please include the amount of money your business earned two months ago."},
    numericality: {only_integer: true, message: "Please make sure the amount you earned two month ago is a number"},
    on: :create

    validates :earned_three_months_ago,
    presence: {message: "Please include the amount of money your business earned three months ago."},
    numericality: {only_integer: true, message: "Please make sure the amount you earned three months ago is a number"},
    on: :create

	validates :password,
    format: {with: /^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/, message: "Your password must be at least 6 characters and must include one number and one letter."},
	on: :create

	validates :terms_of_service, 
	acceptance: { message: "Please accept the terms and conditions."},
	on: :create

	# Step - Personal

	validates :owner_first_name,
	presence: {message: "Please include your first name."},
	if: -> {self.current_step == :personal}

	validates :owner_last_name,
	presence: {message: "Please include your last name."},
	if: -> {self.current_step == :personal}

	validates :name, 
	presence: {message: "Please include your business name."},
	if: -> {self.current_step == :personal}

	validates :phone_number,
	presence: {message: "Please include your phone number."},
	length: {minimum: 10, maximum: 10, message: "Your phone number should be 10 digits long."},
	numericality: {only_integer: true, message: "Please include only digits in your phone number."},
	if: -> {self.current_step == :personal}  

	validates :street_address_one,
	presence: {message: "Please include the first line of your address."},
	if: -> {self.current_step == :personal}

	validates :city,
	presence: {message: "Please include your city."},
	if: -> {self.current_step == :personal}

	validates :state,
	presence: {message: "Please include your state."},
	if: -> {self.current_step == :personal}

	validate :zip_code,
	presence: {message: "Please include your five digit zip code"},
	numericality: {only_integer: true, minimum: 5, maximum: 5, message: "Your zip code should only include number and be 5 digits long"},
	if: -> {self.current_step == :personal}

	validate :business_type,
	presence: {message: "Please include what you sell."},
	if: -> {self.current_step == :personal}

	# Step - Financial

	validates :amount_negative_balance_past_month,
	presence: {message: "Please include the number of days your business bank account has had a negative balance in the last 30 days."},
	numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 30, message: "The amount of days your business bank account has been in the negative should be between 0 and 30."},
	if: -> {self.current_step == :financial}

	validates :average_daily_balance_bank_account,
	presence: {message:  "Please include the average daily balance of  your primary business bank account."},
	numericality: {only_integer: true, message:  "Your average daily balance should be a number."},
	if: -> {self.current_step == :financial}

	# Step - Past Merchants

	validates :total_previous_payback_amount,
	presence: {message: "Please include your total previous payback amount"},
	numericality: {only_integer: true, message: "Your total previous payback amount should be a number"},
	if: -> {self.current_step == :funders}

	validates :total_previous_payback_balance,
	presence: {message: "Please include the current balance on your cash advance."},
	numericality: {only_integer: true, message: "Your current balance should be a number."},
	if: -> {self.current_step == :funders}
  end

end