class Offer < ActiveRecord::Base
	before_create :init

	belongs_to :business #delete
	belongs_to :funder

	belongs_to :lead, inverse_of: :offers
	#before_create :init

	scope :pending, where(state: "pending")
	scope :accepted, where(state: "accepted")
	scope :removed, where(state: "removed")
	scope :rejected, where(state: "rejected")
	scope :funded, where(state: "funded")

	OFFER_TYPE = [new_loan_ach: 1, new_loan_credit: 2, refinance_ach: 3, refinance_credit: 4]

	self.per_page = 10

	
	state_machine :state, :initial => :pending do
	    event :accept do
	      transition [:pending] => :accepted
	    end
    
	    event :reject do
	      transition [:pending] => :rejected
	    end

	    event :fund do
	      transition [:accepted] => :funded
	    end

	    event :remove do 
	    	transition [:accepted, :pending] => :removed
	    end
  	end


  	def init
  		self.factor_rate = self.total_payback_amount / self.cash_advance_amount
  		if self.days_to_collect.nil?
  			self.days_to_collect = self.total_payback_amount / self.daily_merchant_cash_advance 
  		else
  			self.daily_merchant_cash_advance = self.total_payback_amount / self.days_to_collect
  		end
  	end


	def create_random_offers(min, max)
		amount = rand(max - min + 1) + min
		for n in 0..amount
          self.cash_advace_amount
		end
	end

	def self.get_random_months(min, max)
		return rand(max - min + 1) + min
	end

	def self.get_random_rate(min, max)
		return rand * (max - min) + min
	end

	def max_payback_amount(max_advance)
		return max_advance * rate
	end

	def rate
		return 1.32
	end

	def collection_per_day(total_amount, days)
		return total_amount / days
	end

	def self.get_advance_amount(average1, average2, average3, min, max)
		max_merchant_recieve(average1, average2, average3) * get_random_rate(min, max)
	end

	def self.get_three_months_average(average1, average2, average3)
		max_merchant_recieve(average1, average2, average3)
	end

	def self.get_daily_payback(average_daily_balance, rate)
		average_daily_balance * rate
	end

	def self.get_random_rate(min, max)
	    return rand * (max - min) + min
	end

	def self.get_best_possible_offer(average_daily, days, rate)
		return ((average_daily * 0.20 * days) / rate)
	end

	def self.get_days(credit_score_range)
		return 120 if credit_score_range >= 4
		return 80
	end

	private

	  def self.get_random_rate(min, max)
		return rand * (max - min) + min
	  end

	  def self.max_merchant_recieve(average1, average2, average3)
		return (average1 + average2 + average3) / 3
	  end
end
