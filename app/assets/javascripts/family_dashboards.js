window['family_dashboards#home'] = (data) ->
	$(".dialer-section-faq-item-text").hide();
	$(".dialer-section-faq-item-header").on("click", (event) ->
		if $(this).next().is(":visible")
			$(this).next().slideUp();
		else 
			$(this).next().slideDown();
		);