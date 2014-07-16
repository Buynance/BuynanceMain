# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


window['static_pages#index'] = (data) ->

  jQuery(document).ready ->
    setup_carousel()
    setup_slider()   

  jQuery(document).ready ->
    if data.is_production
      mixpanel.track("View - Hompage");
      setup_homepage_analytics()

window['static_pages#privacy'] = (data) ->
  if data.is_production
    mixpanel.track("View - Privacy Policy Page");

window['static_pages#tos'] = (data) ->
  if data.is_production
    mixpanel.track("View - Terms of Service Page");

window['static_pages#blog'] = (data) ->
  if data.is_production
    mixpanel.track("View - Blog Page");

window['static_pages#about'] = (data) ->
  if data.is_production
    mixpanel.track("View - About Page");

window['static_pages#confirm_email'] = (data) ->
  if data.is_production
    if data.is_bank_account_success
      mixpanel.identify(data.email)
      mixpanel.people.set_once({
          'Logged In Bank Account': true
      });
    mixpanel.track("View - Email Confirmation Page")



setup_carousel = () ->

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

setup_slider = () ->
  min = 100
  max = 2000
  $("#slider-range-refi").slider
    range: "min"
    value: 100
    min: min
    max: max
    step: 50
    slide: (event, ui) ->
      $("#slider-range-refi > .ui-slider-handle").html "<br/><div class='homepage-slider-bubble'><span>$" + ui.value.formatMoney(0, ",", ".") + "</span></div>"
      $('.slider-left-value').text "$"+parseInt(ui.value * 0.5).formatMoney(0, ",", ".")
      return
    change: (event, ui) ->
      $("#slider-range-refi > .ui-slider-handle").html "<br/><div class='homepage-slider-bubble'><span>$" + ui.value.formatMoney(0, ",", ".") + "</span></div>"
      $('.slider-left-value').text "$"+parseInt(ui.value * 0.5).formatMoney(0, ",", ".")

      return
  $("span.homepage-slider-left-main-section-label-left-min").html "$ 100<br/> paid per day"
  $("span.homepage-slider-left-main-section-label-right-max").html "$ 2,000<br/> paid per day"

  min2 = 10000
  max2 = 250000
  $("#slider-range-funder").slider
    range: "min"
    value: 10000
    min: min2
    max: max2
    step: 1000
    slide: (event, ui) ->
      $("#slider-range-funder > .amount").html "$" + ui.value
      $("#slider-range-funder > .ui-slider-handle").html "<br/><div class='homepage-slider-bubble'><span>$" + ui.value.formatMoney(0, ",", ".") + "</span></div>"    
      if ui.value == max2
        $('.slider-right-value').text "$"+parseInt(ui.value * 0.075).formatMoney(0, ",", ".")+"+"
      else
         $('.slider-right-value').text "$"+parseInt(ui.value * 0.075).formatMoney(0, ",", ".")

      return
    change: (event, ui) ->
      $("#slider-range-funder > .amount").html "$" + ui.value
      $("#slider-range-funder > .ui-slider-handle").html "<br/><div class='homepage-slider-bubble'><span>$" + ui.value.formatMoney(0, ",", ".") + "</span></div>"
      $('.slider-right-value').text "$"+parseInt(ui.value * 0.075).formatMoney(0, ",", ".")
      if ui.value == max2
        $('.slider-right-value').text "$"+parseInt(ui.value * 0.075).formatMoney(0, ",", ".")+"+"
      else
         $('.slider-right-value').text "$"+parseInt(ui.value * 0.075).formatMoney(0, ",", ".")
      return
 
  $("span.homepage-slider-right-main-section-label-left-min").html "$ 10,000"
  $("span.homepage-slider-right-main-section-label-right-max").html "$ 250,000+"

  return

setup_homepage_analytics = () ->
  $('#funder-slider').find('.ui-slider-handle').click ->
    mixpanel.track("Use - Funder Slider")
  $('#refi-slider').find('.ui-slider-handle').click ->
    mixpanel.track("Use - ReNew Slider")
  $('#funder-slider').find('.homepage-slider-action-subheader').click ->
    mixpanel.track("Click - Funder How It Works Link")
  $('#refi-slider').find('.homepage-slider-action-subheader').click ->
    mixpanel.track("Click - ReNew How It Works Link")
  mixpanel.track_links('.banner-content-information-action-get-financed', 'Click - Homepage Banner Funder Button')
  mixpanel.track_links('.banner-content-information-action-refinance', 'Click - Homepage Banner ReNew Button')
  mixpanel.track_links('#header-logout-button', 'Click - Header Logout Button')
  mixpanel.track_links('#header-login-button', 'Click - Header Login Button')
  mixpanel.track_links('#header-signup-button', 'Click - Header Signup Button')
  mixpanel.track_links('#header-account-button', 'Click - Header Account Button')

  


