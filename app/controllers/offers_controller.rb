class OffersController < ApplicationController

	def index
		@offers = Offer.all 
	end
	
	def update
		offer = Offer.find(params[:id])
		offer.is_active = params[:business][:is_active]
		offer.save
		render :nothing => true
	end

end