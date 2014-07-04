class RoutingNumbersController < ApplicationController
  include Webhookable
 
  after_filter :set_header
  
  skip_before_action :verify_authenticity_token

	def call
		routing_number = RoutingNumber.find(params[:id])
		business = Business.find(routing_number.business_id, no_obfuscated_id: true)
		response = Twilio::TwiML::Response.new do |r|
      		r.Dial "#{routing_number.phone_number}", action: '/forward?Dial=true&FailUrl=http%3A%2F%2Ftwimlets.com%2Fvoicemail%3FEmail%3Dedwin%2540buynance.com%26Message%3DSorry%2520I%2520am%2520unavailable%2520at%2520them%2520moment.%2520Please%2520call%2520me%2520back%2520later.%2520Thank%2520You.%26Transcribe%3Dtrue%26', timeout: '20', caller_id: '7166083596', record:'true'
        end

        routing_number.call_count = routing_number.call_count + 1
        render_twiml response
	end

end