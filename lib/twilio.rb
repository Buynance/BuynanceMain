class Twilio
	twilio_sid = "ACa599ee1205fbc22bab49c5c12586b143"
    twilio_token = "d4944731dadc8bb487486d99169240c9"
    twilio_phone_number = "9146104411"

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

	def self.send_activation_code(phone_number, activation_code)
		send_text(phone_number, "Here is the activation code: #{activation_code}")
	end

	def self.send_new_user_notification(phone_number)
		send_text(phone_number, "A new user has signed up")
	end

	def self.send_new_lead_to_funder_notification(phone_number, lead)
		send_text(phone_number, "A new Lead has entered the funnel")
	end

	private

	def send_text(phone_number, text_message)
		twilio_client.account.sms.messages.create(
			:from => "+1#{twilio_phone_number}",
			:to => phone_number,
			:body => text_message
		)
	end

end