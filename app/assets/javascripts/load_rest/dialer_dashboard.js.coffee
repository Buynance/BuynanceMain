# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window['dialer_dashboards#home'] = (data) ->
	$(".dialer-section-faq-item-text").hide();
	$(".dialer-section-faq-item-header").on("click", (event) ->
		if $(this).next().is(":visible")
			$(this).next().slideUp();
		else 
			$(this).next().slideDown();
		);