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

	def self.create_phone_number(local_number, state, success_url, routing_number_id)
		area_code = local_number[2, 3]

		numbers = @twilio_client.account.available_phone_numbers.get('US').local.list(:area_code => area_code)

		unless numbers.size > 0
			numbers = @twilio_client.account.available_phone_numbers.get('US').local.list(:in_region => state)
			unless numbers.size > 0
				numbers = @twilio_client.account.available_phone_numbers.local.list()
			end
		end

		voice_url = "http://buynance.ngrok.com/call/#{routing_number_id}"
		if Rails.env.production?  
			voice_url = "https://buynance-development.herokuapp.com/call/#{routing_number_id}"
		end

		@twilio_client.account.incoming_phone_numbers.create(
			:voice_url => voice_url,
			:voice_fallback_url => success_url,
			:phone_number => numbers[0].phone_number
			)

  		return numbers[0].phone_number
	end

	def self.generate_voice_xml(phone_number, options={})
		options[:record] ||= true
		options[:transcribe] ||= false

		response = '<?xml version="1.0" encoding="UTF-8"?><Response><Dial timeout="20" record="true">#{phone_number}</Dial></Response>'
		response.text
	end

	def self.generate_twimlet_url(phone_number, options={})
		return "http://twimlets.com/forward?PhoneNumber=#{phone_number[2, 10]}&CallerId=7166083596&Timeout=20&FailUrl=http%3A%2F%2Ftwimlets.com%2Fvoicemail%3FEmail%3Dedwin%2540buynance.com%26Message%3DSorry%2520I%2520am%2520unavailable%2520at%2520them%2520moment.%2520Please%2520call%2520me%2520back%2520later.%2520Thank%2520You.%26Transcribe%3Dtrue%26&"
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