# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


#accept_offer_disclaimer = (id) ->
#	update_url = "/business/insert"
#	$.ajax({
#		type: "PUT",
#		url: update_url, 
#		data: {business: {is_accept_offer_disclaimer: true }} 
#		})
#	$('#disclaimerModal').modal('hide')

#start_timer = () ->
#	hours = parseInt($(".timer-hours").html())
#	minutes = parseInt($(".timer-minutes").html())
#	seconds = parseInt($(".timer-seconds").html())
#	running = true
	#window.setInterval( ->
	#	if hours > 0 or minutes > 0 or seconds > 0
	#		running = true
	#		seconds = parseInt(seconds) - 1
	#		if seconds == 0
	#			if minutes > 0 or hours > 0
	#				minutes = parseInt(minutes) - 1
	#				seconds = 59
	#				if minutes == 0
	#					if hours > 0
	#						minutes = 59
	#						hours = parseInt(hours) - 1
	#	else if running == true 
	#		deactivate_offer(".best-offer")
	#		running = false
	#	if seconds.toString().length == 1
	#		seconds = "0#{seconds}"
	#	if minutes.toString().length == 1
	#		minutes = "0#{minutes}"	
	#	if hours.toString().length == 1
	#		hours = "0#{hours}"		
		
	#	$(".timer-seconds").html(seconds)

	#, 1000)



#$(document).ready( ->
#	start_timer()
#	$(".delete").click( ->
#		deactivate_offer(this)
#	)
#)

#deactivate_offer = (node) ->
#	$(node).closest(".offer").addClass("offer-deleted")
#	id = $(node).closest(".offer").data("id")
#	update_url = ("/offers/"+id+"/update")
#	$.ajax
#		type: "PUT"
#		url: update_url
#		data:
#			offer:
#				is_active: false
#
##$(".btn.offer-btn").click ->
#  id = $(this).data("id")
#  $("#disclaimerModal").find("button.btn").data "id", id
#  console.log $("#disclaimerModal").find("button.btn").data("id")
#  console.log id
#  return

