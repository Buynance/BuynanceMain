# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


window['static_pages#index'] = (data) ->
  mixpanel.track("Page View");



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

  $(".jcarousel-pagination").jcarouselPagination( 
    item: (page) ->
      "<a href=\"#" + page + "\">" + page + "</a>"
    ).on("jcarouselpagination:active", "a", ->
     $(this).addClass "active"
     return
    ).on("jcarouselpagination:inactive", "a", ->
      $(this).removeClass "active"
      return
    ).on "click", (e) ->
      e.preventDefault()
      return

  $(".jcarousel-control-prev").on("jcarouselcontrol:active", ->
    $(this).removeClass "inactive"
    return
  ).on("jcarouselcontrol:inactive", ->
    $(this).addClass "inactive"
    return
  ).jcarouselControl target: "-=1"
  $(".jcarousel-control-next").on("jcarouselcontrol:active", ->
    $(this).removeClass "inactive"
    return
  ).on("jcarouselcontrol:inactive", ->
    $(this).addClass "inactive"
    return
  ).on("click", (e) ->
    e.preventDefault()
    return
  ).jcarouselControl target: "+=1"



  return