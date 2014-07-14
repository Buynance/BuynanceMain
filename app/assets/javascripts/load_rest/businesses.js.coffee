window['businesses#new'] = (data) ->
 if data.is_production
   mixpanel.track("View - Signup Page") ;

window['businesses#qualified_for_market'] = (data) ->
 if data.is_production
   if data.is_mobile_confirmed
     mixpanel.track("Success: Mobile Number Confirmed")
     mixpanel.people.set_once({
      'Success - Mobile Confirmation': data.mobile_disclaimer_accepted
	 } ) ;
   mixpanel.people.set_once({
      'Success - Qualified for Market': true
   } ) ;
   mixpanel.track("View - Qualified For Market Page") ;

window['businesses#disqualified'] = (data) ->
 if data.is_production
   if data.is_mobile_confirmed
     mixpanel.track("Success: Mobile Number Confirmed")
     mixpanel.people.set_once({
      'Success - Mobile Confirmation': data.mobile_disclaimer_accepted
	 } ) ;
   mixpanel.people.set_once({
      'Success - Disqualified Page': true
   } ) ;
   mixpanel.track("View - Disqualified Page") ;


window['businesses#qualified_for_funder'] = (data) ->
 if data.is_production
   if data.is_mobile_confirmed
     mixpanel.track("Success: Mobile Number Confirmed")
     mixpanel.people.set_once({
      'Success - Mobile Confirmation': data.mobile_disclaimer_accepted
	 } ) ;
   mixpanel.people.set_once({
      'Success - Qualified for Funder': true
   } ) ;
   mixpanel.track("View - QUalified For Funder")


window['businesses#confirm_account'] = (data) ->
 if data.is_production
   if data.is_email_confirmed
    mixpanel.track("Success: Mobile Number Confirmed")
    mixpanel.people.set_once({'Success - Email Confirmation': true} ) ;
   mixpanel.track("View - Confirm Email Page") ;

