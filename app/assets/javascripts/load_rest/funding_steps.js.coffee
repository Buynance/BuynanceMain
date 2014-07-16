window['funding_steps#show'] = (data) ->
	if data.is_production == true
		if data.step == "financial"
			mixpanel.identify(data.email)
			mixpanel.track("View - Signup Finance Page");
			mixpanel.people.set_once({
    			'Mobile Disclaimer Accepted': data.mobile_disclaimer_accepted,
    			'Viewed Financial Signup Page': true
			});
			$(".paper-section-bank-login-form-section-payment").css("display", "none")
			$(".is_tax_lien_input").on "change", ->
				if $(".is_tax_lien_input").val() == "true"
					$(".paper-section-bank-login-form-section-payment").css("display", "block")
				else
				 	$(".paper-section-bank-login-form-section-payment").css("display", "none")
		if data.step == "refinance"
			mixpanel.identify(data.email)
			mixpanel.people.set_once({
    			'Mobile Disclaimer Accepted': data.mobile_disclaimer_accepted,
    			"Viewed Refinance Signup Page": true
			});
			mixpanel.track("View - Signup Refinance Page");
		if data.step == "bank_prelogin"
			mixpanel.track("View - Signup Bank Pre-Login Page")
			mixpanel.identify(data.email)
			mixpanel.people.set_once({
				"Viewed Bank Prelogin Signup Page": true
				})
		if data.step == "bank_information"
			mixpanel.track("View - Signup Bank Login Page")
			mixpanel.identify(data.email)
			mixpanel.people.set_once({
				"Viewed Bank Login Signup Page": true
				})
		if data.step == "personal"
			if data.is_signup == true
				mixpanel.alias(data.email);
				mixpanel.people.set({
				    "$email": data.email,
				    "Business Name": data.business_name,
				    "Funding Type": data.funding_type,
				    "Registered User": true
				});
				mixpanel.track("Success - Signup")
			mixpanel.track("View - Signup Personal Page");
			mixpanel.people.set_once({
				"Viewed Personal Information Signup Page": true
				})

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
	    

			

			