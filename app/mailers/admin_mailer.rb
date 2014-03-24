class AdminMailer < ActionMailer::Base
  def qualified_signup(business)
  	@business = business
    mail :subject => "You have a new qualified person signup to buynance",
         :to      => "jay@buynance.com",
         :from    => "Team Buynance <noreply@buynance.com>"
  end

  def offer_notification(business)
    @business = business
    @offer = Offer.find(business.main_offer_id)
    mail :subject => "Offer Accepted",
         :to      => "jay@buynance.com",
         :from    => "Team Buynance <noreply@buynance.com>"
  end
end
