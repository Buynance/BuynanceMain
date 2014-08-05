class Lead < ActiveRecord::Base
	belongs_to :business, inverse_of: :leads
	belongs_to :funder, inverse_of: :leads

	has_many :offers, :dependent => :destroy

	scope :pending, where(state: "pending")
    scope :qualified_market, where(state: "qualified_market")
    scope :sold, where(state: "sold")

    self.per_page = 10

	state_machine :state, :initial => :pending do
        after_transition :on => :qualify_for_market, :do => :set_qualification_type

        event :qualify_for_market do
            transition [:pending] => :qualified_market
        end

        event :sell do 
            transition [:pending, :qualified_market] => :sold 
        end
    end

    def set_qualification_type
        case self.state
        when "qualified_market"
            self.qualification_type = "market"
        end
    end


end
