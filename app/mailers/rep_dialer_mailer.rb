class RepDialerMailer < ActionMailer::Base

	def representative_acceptance(representative)
		@representative = representative
		mail :subject => "Welcome to the family.",
        	 :to      => representative.email,
       		 :from    => "Team Buynance <noreply@buynance.com>"
	end


	def representative_paid(representative_id, business_id, amount)
		@representative = RepDialer.find_by(id: representative_id)
		@business = Business.find_by(id: business_id)
		@amount = ActionController::Base.helpers.number_to_currency(amount)
		mail :subject => "Congratulation, you just got paid!",
      	     :to      => @representative.email,
      		 :from    => "Team Buynance <noreply@buynance.com>"
	end

	def representative_funnel_completion(representative)
		mail :subject => "Representative ##{representative.referral_code} has completed the funnel.",
        	 :to      => "jay@buynance.com, edwin@buynance.com, yuliya@buynance.com, buynancefunder@gmail.com",
       		 :from    => "Team Buynance <noreply@buynance.com>"
	end

	

end

