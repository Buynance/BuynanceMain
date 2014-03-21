# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

accept_offer_disclaimer = (id) ->
	update_url = "/business/insert"
	$.ajax({
		type: "PUT",
		url: update_url, 
		data: {business: {is_accept_offer_disclaimer: true }} 
		})
	$('#disclaimerModal').modal('hide')
