window['businesses#new'] = (data) ->
  if data.is_production
    mixpanel.track("View - Signup Page") ;

window['businesses#qualified_market'] = (data) ->
  if data.is_production
    mixpanel.identify(data.email)
    mixpanel.people.set_once({
      'Confirmed Mobile Number': true,
      'Phone Number Created': true,
      'Qualified for Market': true,
      'Success - Signup'
	  }) ;
    mixpanel.track("View - Qualified For Market Page") 
    mixpanel.track("Success - Confirmed Mobile Number")
    mixpanel.track("Success - New Phone Number Created")

window['businesses#disqualified'] = (data) ->
  if data.is_production
    mixpanel.identify(data.email)
    if data.has_bank_account
      mixpanel.people.set_once({
        'Confirmed Mobile Number': true,
        'Disqualified': true
	    } ) ;
      mixpanel.track("Success - Confirmed Mobile Number")
    else
      mixpanel.people.set_once({
        'Disqualified' : true
      })

    mixpanel.track("View - Disqualified Page") ;


window['businesses#qualified_for_funder'] = (data) ->
  if data.is_production
    mixpanel.identify(data.email)
    mixpanel.track("Success - Mobile Number Confirmed")
    mixpanel.people.set_once({
      'Confirmed Mobile Number': true,
      'Qualified for Funder': true
    } ) ;
    mixpanel.track("View - Qaalified For Funder Page")
    mixpanel.track("Success - Confirmed Mobile Number")
    mixpanel.track("Success - New Phone Number Created")


window['businesses#confirm_account'] = (data) ->
  if data.is_production
    mixpanel.identify(data.email)
    mixpanel.people.set_once({'Confirmed Email': true} ) ;
    mixpanel.track("View - Mobile Number Confirmation") ;

$( document ).ready ->
  if ($("#discovery_type_input option:selected").text() != "I Have a Contest Code") and ($("#discovery_type_input option:selected").text() != "Buynance Family")
    $("#referral_code_input").css("display", "none")
  $("#discovery_type_input").on "change", ->
      if ($("#discovery_type_input option:selected").text() == "I Have a Contest Code") or ($("#discovery_type_input option:selected").text() == "Buynance Family")
        $("#referral_code_input").css("display", "block")
      else
        $("#referral_code_input").css("display", "none")
