class OffersController < ApplicationController

	def index
		@offers = Offer.all 
	end
	
	def update
		offer = Offer.find(params[:offer_id])
		offer.is_active = params[:offer][:is_active]
		offer.save
		render :nothing => true
	end

	def accept
		offer = Offer.find(params[:offer_id])
    	current_business.update_attribute(:main_offer_id, offer.id)
    	current_business.accept_offer
    	redirect_to after_offer_path(:personal)
  	end

end