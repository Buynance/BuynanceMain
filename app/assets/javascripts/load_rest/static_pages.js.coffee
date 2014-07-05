# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).ready ->
  $(".jcarousel").jcarousel({ 
  	animation:
      duration: 800
      easing: "linear"
    wrap: "circular"
    complete: ->
    }).jcarouselAutoscroll
    interval: 10000
    target: "+=1"
    autostart: false 

  return

