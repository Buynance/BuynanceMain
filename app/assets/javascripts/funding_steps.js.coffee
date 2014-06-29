window['funding_steps#show'] = (data) ->
	if data.is_financial == true
		$(".paper-section-bank-login-form-section-payment").css("display", "none")
		$(".is_tax_lien_input").on "change", ->
			if $(".is_tax_lien_input").val() == "true"
				$(".paper-section-bank-login-form-section-payment").css("display", "block")
			else
			 	$(".paper-section-bank-login-form-section-payment").css("display", "none")

window['funding_steps#update'] = (data) ->
	if data.is_financial == true
		$(".is_tax_lien_input").on "change", ->
			if $(".is_tax_lien_input").val() == "true"
				$(".paper-section-bank-login-form-section-payment").css("display", "block")
			else
			 	$(".paper-section-bank-login-form-section-payment").css("display", "none")


		

		