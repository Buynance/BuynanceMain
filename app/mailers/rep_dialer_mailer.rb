class RepDialerMailer < ActionMailer::Base

	def representative_acceptance(representative)
		@representative = representative
		mail :subject => "Welcome to the family.",
        	 :to      => representative.email,
       		 :from    => "Team Buynance <noreply@buynance.com>"
	end


	def representative_payed(representative, business)
		@representative = representative
		@business = business
		mail :subject => "Congratulation, you just got paid!",
      	     :to      => representative.email,
      		 :from    => "Team Buynance <noreply@buynance.com>"
	end

	def representative_funnel_completion(representative)
		mail :subject => "Representative ##{representative.referral_code} has completed the funnel.",
        	 :to      => representative.email,
       		 :from    => "Team Buynance <noreply@buynance.com>"
	end

	

end

