window['businesses#new'] = (data) ->
 if data.is_production
   mixpanel.track("View - Signup Page") ;

window['businesses#qualified_for_market'] = (data) ->
 if data.is_production
   mixpanel.identify(data.email)
   mixpanel.people.set_once({
    'Confirmed Mobile Number': true,
    'Phone Number Created': true,
    'Qualified for Market': true
	 }) ;
   mixpanel.track("View - Qualified For Market Page") ;
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
   if data.is_email_confirmed
    mixpanel.identify(data.email)
    mixpanel.people.set_once({'Confirmed Email': true} ) ;
   mixpanel.track("View - Mobile Number Confirmation") ;

