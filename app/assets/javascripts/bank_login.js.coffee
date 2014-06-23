
$(document).ready ($) ->
	console.log("hello")

	$("#divContent").css("position", "relative")
	$("#divContent").css("width", "200px")
	$("#pnlLogin").css("position", "relative")
	$("#pnlLogin").css("width", "200px")
	$("#loginFormContainer").css("position", "relative")
	$("#loginFormContainer").css("width", "200px")
	$(".loginMainContainer").css("position", "relative")
	$(".loginMainContainer").css("width", "200px")



	div = $("#divContent")

	console.log(div)

IAVResultJSON = (IAVResult) ->
  
  # EXAMPLE USE – PUT YOUR OWN CODE HERE 
  rawJSONString = unescape(IAVResult)
  iavResultObj = $.parseJSON(rawJSONString)
  displayString = ""
  for key of iavResultObj
    displayString += key + " : " + iavResultObj[key] + "\n\r"  if iavResultObj.hasOwnProperty(key)
  alert displayString
  return
$.receiveMessage ((e) ->
  processMessage e.data
  return
), "https://widget.decisionlogic.com"
