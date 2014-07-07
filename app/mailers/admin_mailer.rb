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
    mail :subject => "#{@business.email} Has Accepted An Offer",
         :to      => "jay@buynance.com",
         :from    => "Team Buynance <noreply@buynance.com>"
  end

  def business_qualified_market(business)

  end

  def business_qualified_funder(business)
  end

  def business_qualified_refinance(business)
  end
end
