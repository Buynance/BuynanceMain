class BusinessUser < ActiveRecord::Base
	include BusinessUserValidations
	attr_accessor :current_step

  	obfuscate_id :spin => 89238723
  	belongs_to :business

	before_create :init

	acts_as_authentic do |c|
	    c.login_field = 'email'
	    c.merge_validates_format_of_email_field_options :message => 'Please include a valid email address.'
	    c.merge_validates_confirmation_of_password_field_options :message => "Password confirmation should match the password."
	    c.merge_validates_length_of_password_confirmation_field_options :message => "Password too short (atleast 6 characters)."
	    c.merge_validates_uniqueness_of_email_field_options :message => "Email is already in the system. "
	end # block optional


  	def business
    	Business.find(self.business_id, no_obfuscated_id: true)
  	end

  	def init
  		self.email.downcase! if !self.email.nil?
  	end
end