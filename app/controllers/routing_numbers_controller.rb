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

end