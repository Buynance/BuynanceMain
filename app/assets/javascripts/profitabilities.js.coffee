# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# scroll to bottom when show result
$(window).load  ->
  if included_result
    $("html, body").animate({ scrollTop: $(document).height() }, 1000)

$(document).ready ->
  # empty textfield when user clicks on
  $('#profitability_monthly_cash_collection_amount, #profitability_total_monthly_bills, #profitability_daily_merchant_cash_advance').click ->
    $(this).val('');
