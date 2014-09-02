class RepDialerMailer < ActionMailer::Base

	def representative_acceptance(representative)
		@representative = representative
		mail :subject => "Congratulation, you have been accepted to join the Buynance family!",
         :to      => representative.email,
         :from    => "Team Buynance <noreply@buynance.com>"
	end

end