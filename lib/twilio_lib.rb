class TwilioLib
	twilio_sid = "AC06cc45d9a750321891277d6274021f8a"
    twilio_token = "337632369154ce324e619aa7c92af540"
    @twilio_phone_number = "+17166083596"

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

	def self.send_activation_code(phone_number, activation_code)
		self.send_text(phone_number, "Here is the activation code: #{activation_code}")
	end

	def self.send_new_user_notification(phone_number)
		send_text(phone_number, "A new user has signed up")
	end

	def self.send_new_lead_to_funder_notification(phone_number, lead)
		send_text(phone_number, "A new Lead has entered the funnel")
	end

	def self.create_phone_number(business, area_code)
		phone_number = nil
		routing_number = business.mobile_number
		begin
    		phone_number = client.account.incoming_phone_numbers.create(:friendly_name => business.email,
    			:voice_url => "http://twimlets.com/forward?PhoneNumber=#{routing_number}&",
                :area_code => area_code)

  		rescue StandardError => e
    		phone_number = false
  		end
	end

	private

	def send_opt_code(business)
		code = business.mobile_opt_code
		phone_number = business.mobile_number
		text = "Your buynance mobile code is #{business.mobile_opt_code}"
		send_text(phone_number, text)
	end

	def self.send_text(phone_number, message)
		return_val = @twilio_client.account.messages.create(:body => message,
    		:to => phone_number,
    		:from => @twilio_phone_number)
	end

end