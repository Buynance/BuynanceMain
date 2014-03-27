class OffersController < ApplicationController

	def update
		offer = Offer.find(params[:id])
		offer.is_active = params[:business][:is_active]
		offer.save
		render :nothing => true
	end

end