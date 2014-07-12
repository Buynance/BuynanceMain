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
	length: {minimum: 3, maximum: 35, message: "Please enter a valid business name."},
	on: :create


	validates :is_refinance,
	inclusion: {:in => [true, false], message: "Please select your business financing type."},
	on: :create

	

    #########################################################################
	###################### Step - Personal ##################################
	#########################################################################

	validates :owner_first_name,
	length: {minimum: 2, maximum: 20, message: "Please include a valid first name."},
	if: -> {self.current_step == :personal}

	validates :owner_last_name,
	length: {minimum: 2, maximum: 20, message: "Please include a valid last name."},
	if: -> {self.current_step == :personal}

	validates :street_address_one,
	length: {minimum: 3, maximum: 20, message: "Please include a valid street address."},
	if: -> {self.current_step == :personal}

	validates :city,
	presence: {message: "Please include your city."},
	if: -> {self.current_step == :personal}

	validates :location_state,
	presence: {message: "Please select a state.", allow_blank: false},
	if: -> {self.current_step == :personal}

	validates_format_of :zip_code, 
	:with => /\A\d{5}-\d{4}|\A\d{5}\z/, 
	:message => "Please input a input five digit zipcode.",
	if: -> {self.current_step == :personal}

	validates :phone_number,
	presence: {message: "Please input a valid US phone number."},
	if: -> {self.current_step == :personal}

	validates :mobile_number,
	presence: {message: "Plase input a valid US mobile phone number."},
	if: -> {self.current_step == :personal}

	validates :business_type_id,
	presence: { message: "Please select your business type.", allow_blank: false},
	if: -> {self.current_step == :personal}

	validates :years_in_business,
	presence: { message: "Please select how many years you have been in business.", allow_blank: false},
	if: -> {self.current_step == :personal}


	# Step - Financial
	validates :approximate_credit_score_range,
    presence: {message: "Please select your approximate credit score."},
    if: -> {self.current_step == :financial}
	
	validates :is_tax_lien,
    inclusion: {:in => [true, false], message: "Please select whether you have ever has a tax lien."},
    if: -> {self.current_step == :financial}

    validates :is_payment_plan,
    inclusion: {:in => [true, false], message: "Please select whether you are making payments on your tax lien."},
    if: -> {self.current_step == :financial and self.is_tax_lien == true}

    validates :is_ever_bankruptcy,
    inclusion: {:in => [true, false], message: "Please select whether you have ever filed for bankruptcy."},
    if: -> {self.current_step == :financial}

    validates :is_judgement,
    inclusion: {:in => [true, false], message: "Please select whether you have any judgement."},
    if: -> {self.current_step == :financial}

   # Step - Refinance

   	validates :deal_type,
    inclusion: {:in => [0, 1], message: "Please selectyour deal type."},
    if: -> {self.current_step == :refinance}

    validates :previous_merchant_id,
	presence: { message: "Please select your current funder.", allow_blank: false},
	if: -> {self.current_step == :refinance}

	validates :previous_loan_date,
	presence: { message: "Please select a valid start date for your current funding.", allow_blank: false},
	if: -> {self.current_step == :refinance}

	validates :total_previous_loan_amount,
	presence: { message: "Please input a valid funding amount.", allow_blank: false},
	if: -> {self.current_step == :refinance}

	validates :total_previous_payback_amount,
	presence: { message: "Please input a valid payback amount..", allow_blank: false},
	if: -> {self.current_step == :refinance}

	validates :total_previous_payback_balance,
	presence: { message: "Please input a valid balance amount", allow_blank: false},
	if: -> {self.current_step == :refinance}
	

	validates :is_closing_fee,
    inclusion: {:in => ["false", "true"], message: "Please select whether you paid a closing fee.", allow_blank: false},
    if: -> {self.current_step == :refinance}

    validates :closing_fee,
    presence: { message: "Please include a valid closing fee amount."},
    if: -> {self.current_step == :refinance and self.is_closing_fee == "true"}


    # Step - Disclaimer
	


		


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
