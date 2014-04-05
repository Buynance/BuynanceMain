module BusinessUserValidations
  extend ActiveSupport::Concern
    included do
    	validates :password,
    	format: {with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{6,}\z/, message: "Your password must be at least 6 characters and must include one number and one letter."},
		on: :create

		validates :password,
    	format: {with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{6,}\z/, message: "Your password must be at least 6 characters and must include one number and one letter."},
		if: -> {self.current_step == :recover_password}

	    validates :first_name,
		presence: {message: "Please include your first name."},
		if: -> {self.current_step == :personal}

		validates :last_name,
		presence: {message: "Please include your last name."},
		if: -> {self.current_step == :personal}

		validates :phone_number,
		presence: {message: "Please include your phone number."},
		length: {minimum: 10, maximum: 10, message: "Your phone number should be 10 digits long."},
		numericality: {only_integer: true, message: "Please include only digits in your phone number."},
		if: -> {self.current_step == :personal}

		validates :mobile_number,
		presence: {message: "Please include your mobile number."},
		length: {minimum: 10, maximum: 10, message: "Your mobile number should be 10 digits long."},
		numericality: {only_integer: true, message: "Please include only digits in your mobil number."},
		if: -> {self.current_step == :personal}   
	end
end
