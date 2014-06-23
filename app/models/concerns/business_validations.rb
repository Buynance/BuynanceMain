module BusinessValidations
  extend ActiveSupport::Concern

  included do
  	#########################################################################
	###################### Step - Signup ####################################
	#########################################################################

	#validates :terms_of_service, 
	#acceptance: { message: "Please accept the terms and conditions."},
	#on: :create

	validates :name, 
	length: {minimum: 3, maximum: 20, message: "Your business name should be atleast 3 letters long."},
	on: :create


	validates :is_refinance,
	presence: {message: "An error has occured. Please contact us for further assistance"},
	on: :save

	

    #########################################################################
	###################### Step - Personal ##################################
	#########################################################################

	validates :owner_first_name,
	length: {minimum: 2, maximum: 20, message: "Please include a valid first name."},
	if: -> {self.current_step == :personal}

	validates :owner_last_name,
	length: {minimum: 2, maximum: 20, message: "Please include a valid last name."},
	if: -> {self.current_step == :personal}

	validates :phone_number,
	presence: {message: "Please enter a valid US phone number."},
	if: -> {self.current_step == :personal}

	validates :mobile_number,
	presence: {message: "Plase enter a valid US mobile phone number."},
	if: -> {self.current_step == :personal}

    validates :street_address_one,
	length: {minimum: 3, maximum: 20, message: "Please include a valid street address."},
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

	validate :business_type_id,
	presence: {message: "Please include what your business type."},
	if: -> {self.current_step == :personal}

	validate :years_in_business,
	presence: {message: "Please include how many years you have been in business."},
	if: -> {self.current_step == :personal}


	# Step - Financial

	validates :is_paying_back,
    inclusion: {:in => [true, false], message: "Please select whether you are paying back a merchant cash advance.", allow_blank: false},
    if: -> {self.current_step == :financial}

    validates :approximate_credit_score_range,
    presence: {message: "Please select your approximate credit score."},
    if: -> {self.current_step == :financial}

    validates :is_tax_lien,
    inclusion: {:in => [true, false], message: "Please select whether you have ever has a tax lien."},
    if: -> {self.current_step == :financial}


    validates :is_ever_bankruptcy,
    inclusion: {:in => [true, false], message: "Please select whether you have ever filed for bankruptcy."},
    if: -> {self.current_step == :financial}

    validates :is_judgement,
    inclusion: {:in => [true, false], message: "Please select whether you have any judgement."},
    if: -> {self.current_step == :financial}

   

	# Step - Past Merchants

	#validates :total_previous_payback_amount,
	#presence: {message: "Please include your total previous payback amount"},
	#numericality: {only_integer: true, message: "Your total previous payback amount should be a number"},
	#if: -> {self.current_step == :funders}

	#validates :total_previous_payback_balance,
	#presence: {message: "Please include the current balance on your cash advance."},
	#numericality: {only_integer: true, message: "Your current balance should be a number."},
	#if: -> {self.current_step == :funders}

	#validates :total_previous_payback_balance,
	#presence: {message: "Please include the current balance on your cash advance."},
	#numericality: {only_integer: true, message: "Your current balance should be a number."},
	#if: -> {self.current_step == :funders}
	

  
  end

end