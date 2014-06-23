class BusinessDashboardsController < ApplicationController
	before_filter :require_business_user

	def display_offers
		@business = current_business
		@offers = current_business.leads.last.offers
	end

	def accept_offer
		@business = current_business
		@lead = current_business.leads.last
		@offer = Offer.find(params[:offer_id].to_i)
		@funder = @offer.funder

		@offer.accept
		@business.offers.each do |offer|
			offer.reject if offer.id != @offer.id
		end
		#@offer.remove
		@business.offer_accepted 
		@lead.accept_offer
		@lead.funder_id = @funder.id

		redirect_to account_url
	end

	def offer_accepted	
	end

	def offer_funded
	end

	def reenter_market
	end

end