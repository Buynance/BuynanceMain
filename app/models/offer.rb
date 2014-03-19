class Offer < ActiveRecord::Base
	belongs_to :business
	belongs_to :funder

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

	private

	  def self.get_random_rate(min, max)
		return rand * (max - min) + min
	  end

	  def self.max_merchant_recieve(average1, average2, average3)
		return (average1 + average2 + average3) / 3
	  end
end
