window['funding_steps#show'] = (data) ->
	
	if data.is_production == true
		if data.step == "financial"
			mixpanel.track("View - Signup Finance Page");
			mixpanel.people.set_once({
    			'Success - Mobile Disclaimer Accepted': data.mobile_disclaimer_accepted,
    			'View - Signup Financial': true
			});
			$(".paper-section-bank-login-form-section-payment").css("display", "none")
			$(".is_tax_lien_input").on "change", ->
				if $(".is_tax_lien_input").val() == "true"
					$(".paper-section-bank-login-form-section-payment").css("display", "block")
				else
				 	$(".paper-section-bank-login-form-section-payment").css("display", "none")
		if data.step == "refinance"
			mixpanel.people.set_once({
    			'Success - Mobile Confirmation Accepted': data.mobile_disclaimer_accepted,
    			"View - Signup Refinance": true
			});
			mixpanel.track("View - Signup Refinance Page");
		if data.step == "bank_prelogin"
			mixpanel.track("View - Signup Bank Pre-Login Page")
			mixpanel.people.set_once({
				"View - Signup Bank Prelogin": true
				})
		if data.step == "bank_information"
			mixpanel.track("View - Signup Bank Login Page")
			mixpanel.people.set_once({
				"View - Signup Bank Login": true
				})
		if data.step == "personal"
			if data.is_signup == true
				mixpanel.alias(data.email);
				mixpanel.people.set({
				    "$email": data.email,
				    "business_name": data.business_name,
				    "funding_type": data.funding_type,
				    "success_signup": true
				});
				mixpanel.track("Success - Signup")
			mixpanel.track("View - Signup Personal Page");
			mixpanel.people.set_once({
				"View - Signup Personal": true
				})







$( document ).ready ->
	console.log error_array
	if $(".closing_fee_input_value").val() != "true"
		$(".closing_fee_input_value").css("display", "none")
	$(".is_closing_fee_input").on "change", ->
			if $(".is_closing_fee_input").val() == "true"
				$(".closing_fee_input_value").css("display", "block")
			else
			 	$(".closing_fee_input_value").css("display", "none")

	$(".datepicker").datepicker({dateFormat: 'mm/dd/yy'})
	$(".datepicker").datepicker "option", "showAnim", "slideDown"
	    
	window['funding_steps#update'] = (data) ->
		console.log "update"
		if data.is_production == true
			if data.step == "financial"
				$(".is_tax_lien_input").on "change", ->
					if $(".is_tax_lien_input").val() == "true"
						$(".paper-section-bank-login-form-section-payment").css("display", "block")
					else
					 	$(".paper-section-bank-login-form-section-payment").css("display", "none")
			for error_string in data.error_array
				console.log error_string
				mixpanel.track(("Error - "+error_string+" Input"))




			

			