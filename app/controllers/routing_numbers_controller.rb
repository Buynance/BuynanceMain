class RoutingNumbersController < ApplicationController
  include Webhookable
 
  after_filter :set_header
  
  skip_before_action :verify_authenticity_token

	def call
		routing_number = RoutingNumber.find(params[:id])
		#business = Business.find(routing_number.business_id, no_obfuscated_id: true)
		response = Twilio::TwiML::Response.new do |r|
      r.Dial "#{routing_number.phone_number}", fail_url: "http://twimlets.com/voicemail?Email=edwin%40buynance.com&Message=Thank%20you%20for%20calling.%20Unfortunately%20i%20am%20unavailable.%20Please%20call%20me%20back%20later.&Transcribe=true&", timeout: '20', caller_id: '7166083596', record:'true'
    end

    routing_number.call_count = routing_number.call_count + 1
    render_twiml response
	end

  def accept_lead_from_concussion
    our_phone_number = ""
    customer_phone_number = params[:PrimaryPhone]
    twimlet_url = "http://twimlets.com/menu?Message=You%20have%20a%20new%20lead!%20Please%20press%201%20to%20accept%20it.&Options%5B1%5D=http%3A%2F%2Ftwimlets.com%2Fforward%3FPhoneNumber%3D#{customer_phone_number}%26&"
    response = Twilio::TwiML::Response.new do |r|
      r.Dial "#{our_phone_number}", url: twimlet_url, fail_url: "", timeout: '20', caller_id: '7166083596', record:'true'
    end
  end



end