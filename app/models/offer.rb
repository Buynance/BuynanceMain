class Offer < ActiveRecord::Base
	belongs_to :business
	belongs_to :funder
end
