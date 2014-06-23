class Lead < ActiveRecord::Base
	belongs_to :business, inverse_of: :leads
	belongs_to :funder, inverse_of: :leads

	has_many :offers, :dependent => :destroy

	scope :pending, where(state: "pending")
	scope :awaiting_completion, where(state: "awaiting_completion")
	scope :funded, where(state: "funded")

    self.per_page = 10

	state_machine :state, :initial => :pending do
   
    	event :accept_offer do
      		transition [:pending] => :awaiting_completion
    	end

    	event :reject_offer do
    		transition [:awaiting_completion] => :pending
    	end

    	event :fund do
    		transition [:awaiting_completion] => :funded
    	end
    end

    def self.no_offer_by(funder_id)
        #Offer.where('offers.funder_id == ?', funder_id).leads
        #lead_not_offers = Lead.includes('offers').where('offers.funder_id != ? ', funder_id)
        #lead_not_offers.merge(Lead.where('lead.offers.size == ?', 0))
        Lead.includes('offers').where("offers.funder_id != ? OR offers.id IS NULL", funder_id)
    end

    def self.offer_by(funder_id)
        Lead.includes('offers').where("offers.funder_id == ?", funder_id)
    end
end
