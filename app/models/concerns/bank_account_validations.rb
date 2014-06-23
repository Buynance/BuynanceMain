module BankAccountValidations
  extend ActiveSupport::Concern

  included do

  	validates :account_number,
  	length: {minimum: 2, maximum: 20, message: "Please enter a valid account number."},
  	if: -> {self.current_step == :bank_prelogin}
  	
  	validates :routing_number,
  	length: {minimum: 3, maximum: 20, message: "Please enter a valid routing number."},
  	if: -> {self.current_step == :bank_prelogin}

  end
end
