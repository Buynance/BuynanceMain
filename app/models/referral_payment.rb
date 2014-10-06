require 'paypal_payment'

class ReferralPayment < ActiveRecord::Base

	DEFAULT_AMOUNT = 200.0

	scope :awaiting_payment, -> {where(state: "awaiting_payment")}
	scope :paid,            -> {where(state: "paid")}

	before_save :set_defaults

	belongs_to :rep_dialer
	belongs_to :business

	state_machine :state, :initial => :awaiting_payment do
	    
	    after_transition :on => :pay do |referral_payment, t|
	    	rep_dialer = RepDialer.find_by(id: referral_payment.rep_dialer_id)
        	rep_dialer.total_earning = rep_dialer.total_earning + referral_payment.amount
        	referral_payment.make_payment!
        	referral_payment.deliver_representative_paid_notification!
        	rep_dialer.save
        end

		event :pay do
			transition [:awaiting_payment] => :paid
		end

	end

	def deliver_representative_paid_notification!
    	RepDialerMailer.representative_paid(rep_dialer_id, business_id, self.amount).deliver!
    end
    handle_asynchronously :deliver_representative_paid_notification!

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
	handle_asynchronously :make_payment!

    private

    def set_defaults
    	self.amount ||= DEFAULT_AMOUNT
    end

end
