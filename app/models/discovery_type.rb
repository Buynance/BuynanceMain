class DiscoveryType < ActiveRecord::Base

	ORDERED_NAME = ["Facebook", "Linkedin", "Search Engine", "Buynance Family", "I Have a Contest Code", "Other"]

	def self.get_all_ordered
		ordered = Array.new
		ORDERED_NAME.each do |name|
			type = DiscoveryType.find_by(name: name)
			unless type.nil?
				ordered << type
			end
		end
		return ordered
	end
end
