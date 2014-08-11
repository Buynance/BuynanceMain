window['representatives#add_business'] = (data) ->
	$(".representative-refinance-section").css("display", "none")
	$("#business_is_refinance").on "change", ->
		if $("#business_is_refinance").val() == "true"
			$(".representative-refinance-section").css("display", "block")
		else
		 	$(".representative-refinance-section").css("display", "none")
	$("#business_is_tax_lien").on "change", ->
		if $("#business_is_tax_lien").val() == "true"
			$(".paper-section-bank-login-form-section-payment").css("display", "block")
		else
		 	$(".paper-section-bank-login-form-section-payment").css("display", "none")