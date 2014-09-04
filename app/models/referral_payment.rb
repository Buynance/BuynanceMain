require 'paypal_payment'

class ReferralPayment < ActiveRecord::Base

	scope :awaiting_payment, -> {where(state: "awaiting_payment")}
	scope :payed,            -> {where(state: "payed")}


	state_machine :state, :initial => :awaiting_payment do
	    
	    after_transition :on => :pay do |referral_payment, t|
        	referral_payment.make_payment!
        end

		event :pay do
			transition [:awaiting_payment] => :paid
		end

	end

	def self.add(business_id, representative_id)
		return ReferralPayment.create(business_id: business_id, rep_dialer_id: representative_id)
	end

	def make_payment!
		PaypalPayment.pay(RepDialer.find(self.rep_dialer_id).paypal_email)
		#PaypalPayment.pay("jay.ballentine@buynance.com")
	end
	handle_asynchronously :make_payment!

end
