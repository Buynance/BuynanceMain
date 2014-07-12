window['funding_steps#show'] = (data) ->
	if data.step == "financial"
		mixpanel.track("View - Signup Finance Page");
		$(".paper-section-bank-login-form-section-payment").css("display", "none")
		$(".is_tax_lien_input").on "change", ->
			if $(".is_tax_lien_input").val() == "true"
				$(".paper-section-bank-login-form-section-payment").css("display", "block")
			else
			 	$(".paper-section-bank-login-form-section-payment").css("display", "none")
	if data.step == "personal"
		mixpanel.track("View - Signup Personal Page");
	if data.step == "refinance"
		mixpanel.track("View - Signup Refinance Page");
	if data.step == "bank_prelogin"
		mixpanel.track("View - Signup Bank Pre-Login Page")
	if data.step == "bank_information"
		mixpanel.track("View - Signup Bank Login Page")



window['funding_steps#update'] = (data) ->
	if data.step == "financial"
		$(".is_tax_lien_input").on "change", ->
			if $(".is_tax_lien_input").val() == "true"
				$(".paper-section-bank-login-form-section-payment").css("display", "block")
			else
			 	$(".paper-section-bank-login-form-section-payment").css("display", "none")


$( document ).ready ->
	if $(".closing_fee_input_value").val() != "true"
		$(".closing_fee_input_value").css("display", "none")
	$(".is_closing_fee_input").on "change", ->
			if $(".is_closing_fee_input").val() == "true"
				$(".closing_fee_input_value").css("display", "block")
			else
			 	$(".closing_fee_input_value").css("display", "none")

	$(".datepicker").datepicker({dateFormat: 'mm/dd/yy'})
	$(".datepicker").datepicker "option", "showAnim", "slideDown"
    




		

		