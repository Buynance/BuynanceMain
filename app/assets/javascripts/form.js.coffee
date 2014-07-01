hide_or_show = ->
  s1 = document.getElementById("business_is_tax_lien")
  s2 = document.getElementsByClassName("tax_lien_payment_plan")
  s2.style.display = "block"  if s1.options[s1.selectedIndex].text is "Yes"
  s2.style.display = "none"  if s1.options[s1.selectedIndex].text is "No"
  return

#$(document).ready( ->
  #s2 = document.getElementsByClassName("tax_lien_payment_plan")
  #s2.style.display = "none"
  #return
#) 