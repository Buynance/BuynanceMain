require 'paypal_payment'

class ReferralPayment < ActiveRecord::Base

	DEFAULT_AMOUNT = 100.0

	scope :awaiting_payment, -> {where(state: "awaiting_payment")}
	scope :paid,            -> {where(state: "paid")}

	before_save :set_defaults

	belongs_to :rep_dialer
	belongs_to :business

	state_machine :state, :initial => :awaiting_payment do
	    
	    after_transition :on => :pay do |referral_payment, t|
        	referral_payment.make_payment!
        end

		event :pay do
			transition [:awaiting_payment] => :paid
		end

	end

	def inititalize
		self.amount = DEFAULT_AMOUNT
	end

	def self.add(business_id, representative_id)
		return ReferralPayment.create(business_id: business_id, rep_dialer_id: representative_id)
	end

	def make_payment!
		PaypalPayment.pay(RepDialer.find(self.rep_dialer_id).paypal_email, self.amount)
		#PaypalPayment.pay("jay.ballentine@buynance.com")
	end
	#handle_asynchronously :make_payment!

    private

    def set_defaults
    	self.amount ||= DEFAULT_AMOUNT
    end

end
