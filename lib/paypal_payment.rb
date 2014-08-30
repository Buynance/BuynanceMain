require 'paypal-sdk-adaptivepayments'

class PaypalPayment

	PayPal::SDK.configure(
	  :mode      => "sandbox",  # Set "live" for production
	  :app_id    => "APP-80W284485P519543T",
	  :username  => "buynancefunder-facilitator_api1.gmail.com",
	  :password  => "TKKQBX9RE4XJ7U6J",
	  :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31A.BptIXiDoBsratHXvbekedvpOqS" )

	@api = PayPal::SDK::AdaptivePayments.new

	def self.pay(email)
		@pay = @api.build_pay({
		  :actionType => "PAY",
		  :cancelUrl => "http://localhost:3000/samples/adaptive_payments/pay",
		  :currencyCode => "USD",
		  :feesPayer => "SENDER",
		  :senderEmail => "buynancefunder-facilitator@gmail.com",
		  :receiverList => {
		    :receiver => [{
		      :amount => 100.0,
		      :email => email }] },
		  :returnUrl => "http://localhost:3000/samples/adaptive_payments/pay",
		  :ipnNotificationUrl => "http://localhost:3000/samples/adaptive_payments/ipn_notify"
		})	

		@response = @api.pay(@pay)	

		if @response.success? && @response.payment_exec_status != "ERROR"
		  puts @response.payKey
		  puts @api.payment_url(@response)  # Url to complete payment
		else
		  puts @response.error[0].message
		end
	end

end