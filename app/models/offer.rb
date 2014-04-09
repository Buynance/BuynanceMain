class Offer < ActiveRecord::Base
	belongs_to :business
	belongs_to :funder
	#before_create :init

	scope :active, where(is_active: true)
	scope :inactive, where(is_active: false)
	scope :best_offers, where(is_best_offer: true)
	
	state_machine :state, :initial => :awaiting_action do
	    event :accept do
	      transition [:awaiting_action] => :accepted
	    end
    
	    event :reject do
	      transition [:awaiting_action] => :rejected
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
