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
  jQuery(document).ready ->
    if data.is_production
      mixpanel.track("View - Friends Dashboard");
      setup_friends_homepage_analytics()

setup_friends_homepage_analytics = () ->
  mixpanel.track_links('#friends-banner-signup', 'Click - Friends Banner Signup Button') #
  mixpanel.track_links('#friends-header-logout', 'Click - Friends Header Logout Button')
  mixpanel.track_links('#friends-header-login', 'Click - Friends Header Login Button')
  mixpanel.track_links('#friends-header-account', 'Click - Friends Header Account Button')

  $('.friends-faq-1').click ->
    mixpanel.track("Click - Friends FAQ Question 1")
  $('.friends-faq-2').click ->
    mixpanel.track("Click - Friends FAQ Question 2")
  $('.friends-faq-3').click ->
    mixpanel.track("Click - Friends FAQ Question 3")
  $('.friends-faq-4').click ->
    mixpanel.track("Click - Friends FAQ Question 4")
  $('.friends-faq-5').click ->
    mixpanel.track("Click - Friends FAQ Question 5")
  $('.friends-faq-6').click ->
    mixpanel.track("Click - Friends FAQ Question 6")
  $('.friends-faq-7').click ->
    mixpanel.track("Click - Friends FAQ Question 7")
  $('.friends-faq-8').click ->
    mixpanel.track("Click - Friends FAQ Question 8")
  $('.friends-faq-9').click ->
    mixpanel.track("Click - Friends FAQ Question 9")

window['dialer_dashboards#questionnaire'] = (data) ->
  if data.is_production
    mixpanel.identify(data.email)
    mixpanel.people.set_once({
      'Type': 'Friends',
      'Name': data.name,
      'Success - Signup'
    }) ;
    mixpanel.track("View - Friends Questionnaire") 

window['dialer_dashboards#account'] = (data) ->
  if data.is_production
    if data.is_pending
      mixpanel.identify(data.email)
      mixpanel.people.set_once({
        'Completed Questionnaire': true
      }) ;
      mixpanel.track("View - Friends Pending Screen")

    if data.is_accepted
      mixpanel.identify(data.email)
      mixpanel.people.set_once({
        'Is Accepted': true
      }) ;
      mixpanel.track("View - Friends Accepted Screen")

    if data.is_rejected
      mixpanel.identify(data.email)
      mixpanel.people.set_once({
        'Is Rejected': true
      }) ;
      mixpanel.track("View - Friends Rejected Screen") 


  

  

