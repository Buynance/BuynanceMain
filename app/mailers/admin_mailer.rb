class AdminMailer < ActionMailer::Base
  def qualified_signup(business)
  	@business = business
    mail :subject => "You have a new qualified person signup to buynance",
         :to      => "jay@buynance.com",
         :from    => "Team Buynance <noreply@buynance.com>"
  end
end
