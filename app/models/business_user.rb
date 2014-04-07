class BusinessUser < ActiveRecord::Base
	include BusinessUserValidations
	attr_accessor :current_step

  	obfuscate_id :spin => 89238723
  	belongs_to :business

	before_create :init

	validate :email_does_not_contain_test,
      on: :create

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

  def deliver_recovery_email!
    BusinessMailer.delay.recovery_email(self)
  end

  private

  	def init
  		self.email.downcase! if !self.email.nil?
      self.recovery_code = Business.generate_activation_code
  	end

  	def email_does_not_contain_test
      first_part_of_email = self.email.gsub(/\@(.*)/, "")
      second_part_of_email = self.email.gsub(/(.+?)@|([.]|com|net|org|gov|edu)/,"")
      errors.add(:email, "Please enter a valid email address.") if (first_part_of_email == "test" || first_part_of_email == "testing" || second_part_of_email == 'test' || second_part_of_email == 'testing')
    end
end