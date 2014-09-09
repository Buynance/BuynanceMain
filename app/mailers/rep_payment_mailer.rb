class RepPaymentMailer < ActionMailer::Base

	def representative_payed(representative)
		@representative = representative
		mail :subject => "Welcome to the family.",
         :to      => representative.email,
         :from    => "Team Buynance <noreply@buynance.com>"
	end

end