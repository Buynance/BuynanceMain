require 'paypal-sdk-adaptivepayments'

class PaypalPayment

	PayPal::SDK.configure(
	  :mode      => "live",  # Set "live" for production
	  :app_id    => "APP-6047782737873800A",
	  :username  => "buynancefunder_api1.gmail.com",
	  :password  => "RA6XJT4S4F749QWF",
	  :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31Aj7EYAljIS.6NNUy-upkTW5BtCl7" )

	@api = PayPal::SDK::AdaptivePayments.new

	def self.pay(email, amount)
		@pay = @api.build_pay({
		  :actionType => "PAY",
		  :cancelUrl => "http://localhost:3000/samples/adaptive_payments/pay",
		  :currencyCode => "USD",
		  :feesPayer => "SENDER",
		  :senderEmail => "buynancefunder@gmail.com",
		  :receiverList => {
		    :receiver => [{
		      :amount => amount,
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