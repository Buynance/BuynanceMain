# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# scroll to bottom when show result
$(window).load  ->
  if typeof(included_result) != "undefined" && included_result
    location = $(".result-box").offset().top
    $("html, body").animate({ scrollTop: location}, 1000)
  
$(document).ready ->
   $('.selectpicker').selectpicker();
  # empty textfield when user clicks on
  monthly_cash_collected = 50000
  monthly_bill = 40000
  button_node = document.getElementById("hidden_button")
  
  $('#profitability_monthly_cash_collection_amount, #profitability_total_monthly_bills, #profitability_daily_merchant_cash_advance').click ->
    $(this).val('');
  

  $("#profitability_monthly_cash_collection_amount").blur -> 
    monthly_cash_collected_node = document.getElementById("profitability_monthly_cash_collection_amount")
    monthly_bill_node = document.getElementById("profitability_total_monthly_bills")

    monthly_cash_collected = ~~($(this).val().replace("$", ""))
    console.log("1 -"+monthly_cash_collected+" 2-"+monthly_bill)
    $(monthly_bill_node).attr("max", monthly_bill)
    if(monthly_cash_collected < monthly_bill)
      monthly_bill_node.setCustomValidity("");
      $(this).attr("min", monthly_bill)
      monthly_cash_collected_node.setCustomValidity("Monthly earnings should not be less than the total monthly bills")
    else
      if (monthly_bill != 0)
        monthly_bill_node.setCustomValidity("")
      monthly_cash_collected_node.setCustomValidity("")
    if(monthly_cash_collected == 0)
      monthly_cash_collected_node.setCustomValidity("Please enter a valid value");

  $("#profitability_total_monthly_bills").blur ->
    monthly_cash_collected_node = document.getElementById("profitability_monthly_cash_collection_amount");
    monthly_bill_node = document.getElementById("profitability_total_monthly_bills");
    
    monthly_bill = ~~($(this).val().replace("$",""))
    console.log("1 -"+monthly_cash_collected+" 2-"+monthly_bill)
    $(monthly_cash_collected_node).attr("min", monthly_bill)
    if(monthly_cash_collected < monthly_bill)
      monthly_cash_collected_node.setCustomValidity("")
      $(this).attr("max", monthly_cash_collected)
      monthly_bill_node.setCustomValidity("Total Monthly bills should not be greater than monthly earnings");        
    else
      if(monthly_cash_collected != 0) 
        monthly_cash_collected_node.setCustomValidity("")
      monthly_bill_node.setCustomValidity("")
    if(monthly_bill == 0)
      monthly_bill_node.setCustomValidity("Please enter a valid value");        
      