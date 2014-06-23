class FunderDashboardsController < ApplicationController
	before_filter :require_funder, :only => [:main, :make_offer]

	layout "funder_layout"

	# Pages

	def main
		@offer = Offer.new
		@leads = Lead.no_offer_by(current_funder.id).paginate(page: params[:page])
		@funder = current_funder
	end

	def pending_bids
		@leads = Lead.offer_by(current_funder.id).paginate(page: params[:page])
		@funder = current_funder
	end

	def accepted_bids
	end

	def won_bids
	end

	def lost_bids
	end

	# Actions

	def make_offer
		@offer = Offer.new(offer_params)
		funder_id = current_funder.id
		@offer.funder_id = funder_id
		if @offer.save
			redirect_to action: 'main'
		end
	end


	private

	private

	def offer_params
      return params.require(:offer).permit(:stipulations, :offer_type, :daily_merchant_cash_advance, :total_payback_amount, :cash_advance_amount, :days_to_collect, :lead_id, :daily_merchant_cash_advance) 
    end
end