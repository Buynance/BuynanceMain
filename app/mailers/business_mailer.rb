class BusinessMailer < ActionMailer::Base
  def email_registration(business)
    @business = business
    mail :subject => "Complete Your Registration With Buynance",
         :to      => business.email,
         :from    => "Team Buynance <noreply@buynance.com>"
  end

  def welcome(business)
  	mail :subject => "Welcome to Buynance",
         :to      => business.email,
         :from    => "Team Buynance <noreply@buynance.com>"
  end

  def average_less_than(business)
    mail :subject => "We will keep in touch",
         :to      => business.email,
         :from    => "Team Buynance <noreply@buynance.com>"
  end

  def recovery_email(business_user)
    @business_user = business_user
    mail :subject => "Recover your account",
         :to      => business_user.email,
         :from    => "Team Buynance <noreply@buynance.com>"
  end

  def qualified_signup(business)
    @business = business
    mail :subject => "You have a new qualified person signup to buynance",
         :to      => "edwin@buynance.com",
         :from    => "edwin@buynance.com"
  end


  
  
end
