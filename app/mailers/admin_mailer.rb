class AdminMailer < ActionMailer::Base

  def qualified_signup(business_id)
  	@business = Business.find(business_id)
    mail :subject => "You have a new qualified person signup to Buynance",
         :to      => "jay@buynance.com",
         :from    => "Team Buynance <noreply@buynance.com>"
  end

  def new_representative_signup(representative)
    @rep_dialer = representative
    mail :subject => "You have a new Friends of Buynance Sign up",
         :to      => "edwin@buynance.com, yuliya@buynance.com, buynancefunder@gmail.com",
         :from    => "Team Buynance <noreply@buynance.com>"
  end

  def new_family_signup(representative)
    @rep_dialer = representative
    mail :subject => "New Family Recruit",
         :to      => "edwin@buynance.com, yuliya@buynance.com, buynancefunder@gmail.com",
         :from    => "Team Buynance <noreply@buynance.com>"
  end

  def new_representative_lead(representative_id, business_id) 
    @business = Business.find_by(id: business_id)
    @rep_dialer = RepDialer.find_by(id: representative_id)
    mail :subject => "A representative is awaiting payment!",
         :to      => "edwin@buynance.com, yuliya@buynance.com, buynancefunder@gmail.com",
         :from    => "Team Buynance <noreply@buynance.com>"
  end

end
