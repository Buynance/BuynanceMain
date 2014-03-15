Number::formatMoney = (decPlaces, thouSeparator, decSeparator) ->
  n = this
  decPlaces = (if isNaN(decPlaces = Math.abs(decPlaces)) then 2 else decPlaces)
  decSeparator = (if decSeparator is `undefined` then "." else decSeparator)
  thouSeparator = (if thouSeparator is `undefined` then "," else thouSeparator)
  sign = (if n < 0 then "-" else "")
  i = parseInt(n = Math.abs(+n or 0).toFixed(decPlaces)) + ""
  j = (if (j = i.length) > 3 then j % 3 else 0)
  sign + ((if j then i.substr(0, j) + thouSeparator else "")) + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thouSeparator) + ((if decPlaces then decSeparator + Math.abs(n - i).toFixed(decPlaces).slice(2) else ""))

convert_currency = (element) ->
  $(element).each (index) ->
    number = $(this).val()
    if (typeof number != 'undefined' and number.length > 0)
      number = number.replace(/[^\d.]/g, "")
      new_value = parseInt(number).formatMoney(2, ",", ".")
      $(this).val("$"+new_value)

convert_phone = (element) ->
  number = $(element).val()
  if (typeof number != 'undefined' and number.length > 0)
    number = number.replace(/\D/g, "")
    number = number.replace(/\A1/, "")
    while number.length < 10
      number = number + "x"
    $(element).val("("+number.substring(0,3)+") "+number.substring(3,6)+" - "+number.substring(6,10))

$(document).ready ->
  convert_currency(".currency_convert")
  convert_phone(".phone_convert")

  $(".currency_convert").change ->
  	convert_currency(this)

  $(".phone_convert").change ->
    convert_phone (this)

  $('input.form-control').focus ->
    $(this).val('')