class RepDialerMailer < ActionMailer::Base

	def representative_acceptance(representative)
		@representative = representative
		mail :subject => "Welcome to the family.",
        	 :to      => representative.email,
       		 :from    => "Team Buynance <noreply@buynance.com>"
	end

	def new_representative_alert(representative)
		@rep = rep
		mail :subject => "A new representaitve has signed up!",
	    	 :to => "edwin@buynance.com",
	   	     :from => "Team Buynance <noreply@buynance.com>"
	end

	def representative_payed(representative)
		@representative = representative
		mail :subject => "Congratulation, you have recieved a Payment!",
      	     :to      => representative.email,
      		 :from    => "Team Buynance <noreply@buynance.com>"
	end

	def representative_funnel_completion(representative)
		mail :subject => "Representative ##{representative.referral_code} has completed the funnel.",
        	 :to      => representative.email,
       		 :from    => "Team Buynance <noreply@buynance.com>"
	end

	

end

