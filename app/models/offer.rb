class Offer < ActiveRecord::Base
	belongs_to :business
	belongs_to :funder

	def max_merchant_recieve(average1, average2, average3)
		return (average1 + average2 + average3) / 3
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
end
