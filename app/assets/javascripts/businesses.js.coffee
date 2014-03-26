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

start_timer = () ->
	hours = parseInt($(".timer-hours").html())
	minutes = parseInt($(".timer-minutes").html())
	seconds = parseInt($(".timer-seconds").html())
	console.log(hours+":"+minutes+":"+seconds)
	window.setInterval( ->
		if hours > 0 or minutes > 0 or seconds > 0
			console.log(hours+":"+minutes+":"+seconds)
			seconds = parseInt(seconds) - 1
			if seconds == 0
				if minutes > 0 or hours > 0
					minutes = parseInt(minutes) - 1
					seconds = 59
					if minutes == 0
						if hours > 0
							minutes = 59
							hours = parseInt(hours) - 1
				else
					deactivate_offer(".best-offer")
		if seconds.toString().length == 1
			seconds = "0#{seconds}"
		if minutes.toString().length == 1
			minutes = "0#{minutes}"	
		if hours.toString().length == 1
			hours = "0#{hours}"		
		
		$(".timer-seconds").html(seconds)
		$(".timer-minutes").html(minutes)
		$(".timer-hours").html(hours)

	, 1000)



$(document).ready( ->
	console.log($(".timeleft"))
	start_timer()
	$(".delete").click( ->
		deactivate_offer(this)
	)
)

deactivate_offer = (node) ->
	$(node).closest(".offer").addClass("offer-deleted")
	id = $(node).closest(".offer").data("id")
	console.log(id)
	update_url = ("/offer/update/" + id)
	$.ajax
		type: "PUT"
		url: update_url
		data:
			business:
				is_active: false

