$(document).ready ->
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
  $("span.homepage-slider-left-main-section-label-left-min").html "$ 100<br/> per day"
  $("span.homepage-slider-left-main-section-label-right-max").html "$ 2,000<br/> per day"

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
