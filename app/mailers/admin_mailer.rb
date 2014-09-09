class AdminMailer < ActionMailer::Base

  def qualified_signup(business_id)
  	@business = Business.find(business_id, no_obfuscated_id: true)
    mail :subject => "You have a new qualified person signup to buynance",
         :to      => "jay@buynance.com",
         :from    => "Team Buynance <noreply@buynance.com>"
  end

  def new_representative_signup(representative)
    @rep_dialer = representative
    mail :subject => "You have a new Friends of Buynance Signup",
         :to      => "edwin@buynance.com",
         :from    => "Team Buynance <noreply@buynance.com>"
  end

end
