$(document).ready ->
  min = 100
  max = 2000
  $("#slider-range-refi").slider
    range: "min"
    value: 100
    min: min
    max: max
    slide: (event, ui) ->
      $("#slider-range-refi > .ui-slider-handle").html "<br/><div class='homepage-slider-bubble'><span>$" + $("#slider-range-refi").slider("value") + "</span></div>"
      return
  $("span.homepage-slider-left-main-section-label-left-min").html "$ 100<br/> per day"
  $("span.homepage-slider-left-main-section-label-right-max").html "$ 2,000<br/> per day"

  min2 = 10000
  max2 = 250000
  $("#slider-range-funder").slider
    range: "min"
    value: 100
    min: min2
    max: max2
    slide: (event, ui) ->
      $("#slider-range-funder > .amount").html "$" + ui.value
      $("#slider-range-funder > .ui-slider-handle").html "<br/><div class='homepage-slider-bubble'><span>$" + $("#slider-range-funder").slider("value") + "</span></div>"
      return

  $("span.homepage-slider-right-main-section-label-left-min").html "$ 10,000"
  $("span.homepage-slider-right-main-section-label-right-max").html "$ 250,000+"

  return
