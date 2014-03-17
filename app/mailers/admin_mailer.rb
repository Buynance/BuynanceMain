class AdminMailer < ActionMailer::Base
  def qualified_signup
    mail :subject => "You have a new qualified person signup to buynance",
         :to      => "edwin@buynance.com",
         :from    => "Team Buynance <noreply@buynance.com>"
  end
end
