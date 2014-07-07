class Funder < ActiveRecord::Base
	has_many :offers, :dependent => :destroy
	has_many :leads

	acts_as_authentic do |c|
	    c.login_field = 'email'
        #c.maintain_sessions = false
	    c.merge_validates_format_of_email_field_options :message => 'Please include a valid email address.'
	    c.merge_validates_confirmation_of_password_field_options :message => "Password confirmation should match the password."
	    c.merge_validates_length_of_password_confirmation_field_options :message => "Password too short (atleast 6 characters)."
	    c.merge_validates_uniqueness_of_email_field_options :message => "Email is already in the system. "
	end # block optional

	def qualify_for_refi(business)

	end

	def qualify_for_funder(business)
	
	end

end
