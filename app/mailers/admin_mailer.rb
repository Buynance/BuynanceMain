class AdminMailer < ActionMailer::Base
  def qualified_signup(business_id)
  	@business = Business.find(business_id, no_obfuscated_id: true)
    mail :subject => "You have a new qualified person signup to buynance",
         :to      => "jay@buynance.com",
         :from    => "Team Buynance <noreply@buynance.com>"
  end

  def offer_notification(business)
    @business = business
    @offer = Offer.find(business.main_offer_id)
    mail :subject => "#{@business.email} Has Accepted An Offer",
         :to      => "jay@buynance.com",
         :from    => "Team Buynance <noreply@buynance.com>"
  end

  def business_qualified_market(business)

  end

  





end
