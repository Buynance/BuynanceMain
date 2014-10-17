window['family_dashboards#home'] = (data) ->
  $(".dialer-section-faq-item-text").hide();
  $(".dialer-section-faq-item-header").on("click", (event) ->
    if $(this).next().is(":visible")
      $(this).next().slideUp();
    else 
      $(this).next().slideDown();
    );

  jQuery(document).ready ->
    if data.is_production
      mixpanel.track("View - Family Dashboard");
      setup_family_homepage_analytics()

setup_family_homepage_analytics = () ->
  mixpanel.track_links('#family-banner-signup', 'Click - Family Banner Signup Button') #
  mixpanel.track_links('#family-header-logout', 'Click - Family Header Logout Button')
  mixpanel.track_links('#family-header-login', 'Click - Family Header Login Button')
  mixpanel.track_links('#family-header-account', 'Click - Family Header Account Button')

  $('.family-faq-1').click ->
    mixpanel.track("Click - Family FAQ Question 1")
  $('.family-faq-2').click ->
    mixpanel.track("Click - Family FAQ Question 2")
  $('.family-faq-3').click ->
    mixpanel.track("Click - Family FAQ Question 3")
  $('.family-faq-4').click ->
    mixpanel.track("Click - Family FAQ Question 4")
  $('.family-faq-5').click ->
    mixpanel.track("Click - Family FAQ Question 5")
  $('.family-faq-6').click ->
    mixpanel.track("Click - Family FAQ Question 6")
  $('.family-faq-7').click ->
    mixpanel.track("Click - Family FAQ Question 7")
  $('.family-faq-8').click ->
    mixpanel.track("Click - Family FAQ Question 8")

window['family_dashboards#questionnaire'] = (data) ->
  if data.is_production
    mixpanel.identify(data.email)
    mixpanel.people.set_once({
      'Type': 'Family',
      'Name': data.name,
      'Success - Signup'
    }) ;
    mixpanel.track("View - Family Questionnaire") 

window['family_dashboards#account'] = (data) ->
  if data.is_production
    if data.is_pending
      mixpanel.identify(data.email)
      mixpanel.people.set_once({
        'Completed Questionnaire': true
      }) ;
      mixpanel.track("View - Family Pending Screen")

    if data.is_accepted
      mixpanel.identify(data.email)
      mixpanel.people.set_once({
        'Is Accepted': true
      }) ;
      mixpanel.track("View - Family Accepted Screen")

    if data.is_rejected
      mixpanel.identify(data.email)
      mixpanel.people.set_once({
        'Is Rejected': true
      }) ;
      mixpanel.track("View - Family Rejected Screen") 


  

  
