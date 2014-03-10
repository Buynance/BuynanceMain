class BusinessMailer < ActionMailer::Base
  def email_registration(business)
    @business = business
    mail :subject => "Complete Your Registration With Buynance",
         :to      => business.email,
         :from    => "edwin@buynance.com"
  end

  def welcome(business)
  	mail :subject => "Welcome to Buynance",
         :to      => business.email,
         :from    => "edwin@buynance.com"
  end

  def average_less_than(business)
    mail :subject => "We will keep in touch",
         :to      => business.email,
         :from    => "edwin@buynance.com"
  end
  
end
