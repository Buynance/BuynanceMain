class BusinessType < ActiveRecord::Base
	belongs_to :business_type_division, inverse_of: :business_types

	has_many :businesses
end
