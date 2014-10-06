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

  def qualified_user(business)
    @business = business
    mail :subject => "New Qualified User",
         :to      => "jay@buynance.com, yuliya@buynance.com",
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
         :from    => "Team Buynance <noreply@buynance.com>"
  end

  def bank_interuption(business)
    @business = business
    mail :subject => "Warning: A user has dropped out of bank login!",
         :to      => "jay@buynance.com, yuliya@buynance.com",
         :from    => "Team Buynance <noreply@buynance.com>"
  end

  def jared_success_signup(business)
    @business = business
    mail :subject => "We have matched you with a funder!",
         :to      => business.email,
         :from    => "Yuliya Glazman <yuliya@buynance.com>"
  end

  def offer_accepted(business)
    @business = business
    mail :subject => "Just one more step.",
         :to      => business.email,
         :from    => "Yuliya Glazman <yuliya@buynance.com>"
  end
  
  
end
