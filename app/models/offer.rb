class Offer < ActiveRecord::Base
	before_create :init

	belongs_to :business 
	#before_create :init

	scope :pending, where(state: "pending")
	scope :accepted, where(state: "accepted")
	scope :rejected, where(state: "rejected")
	
	state_machine :state, :initial => :pending do
	    event :accept do
	      transition [:pending] => :accepted
	    end
    
	    event :reject do
	      transition [:pending] => :rejected
	    end
  	end

  	def self.create_offers(business)
  		unless business.bank_account.nil?
  			ammount = (business.bank_account.average_monthly_deposit * 12) * 0.01
  			offer1 = Offer.create(name: "Buynance Fast Advance",business_id: business.id, cash_advance_amount: amount, total_payback_amount: (amount * 1.4))
  			ammount = ((business.bank_account.average_monthly_deposit * 12) * 0.01) + (business.bank_account.average_monthly_deposit * 0.15)
  			offer2 = Offer.create(name: "Buynance Fast Advance Plus", business_id: business.id, cash_advance_amount: amount)
  			ammount = (business.bank_account.average_monthly_deposit * 12) * 0.12
  			offer3 = Offer.create(name: "Affiliate Advance", business_id: business.id, cash_advance_amount: amount)
  		end
  	end

end
