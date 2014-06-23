#
#
#jQuery Browser Plugin
# * Version 2.3
# * 2008-09-17 19:27:05
# * URL: http://jquery.thewikies.com/browser
# * Description: jQuery Browser Plugin extends browser detection capabilities and can assign browser selectors to CSS classes.
# * Author: Nate Cavanaugh, Minhchau Dang, & Jonathan Neal
# * Copyright: Copyright (c) 2008 Jonathan Neal under dual MIT/GPL license.
# * JSLint: This javascript file passes JSLint verification.
#
#jslint
#   bitwise: true,
#   browser: true,
#   eqeqeq: true,
#   forin: true,
#   nomen: true,
#   plusplus: true,
#   undef: true,
#   white: true
#
#global
#   jQuery
#
(($) ->
  $.browserTest = (a, z) ->
    u = "unknown"
    x = "X"
    m = (r, h) ->
      i = 0

      while i < h.length
        r = r.replace(h[i][0], h[i][1])
        i = i + 1
      r

    c = (i, a, b, c) ->
      r = name: m((a.exec(i) or [
        u
        u
      ])[1], b)
      r[r.name] = true
      r.version = (c.exec(i) or [
        x
        x
        x
        x
      ])[3]
      r.version = "2.0"  if r.name.match(/safari/) and r.version > 400
      r.version = (if ($.browser.version > 9.27) then "futhark" else "linear_b")  if r.name is "presto"
      r.versionNumber = parseFloat(r.version, 10) or 0
      r.versionX = (if (r.version isnt x) then (r.version + "").substr(0, 1) else x)
      r.className = r.name + r.versionX
      r

    a = ((if a.match(/Opera|Navigator|Minefield|KHTML|Chrome/) then m(a, [
      [
        /(Firefox|MSIE|KHTML,\slike\sGecko|Konqueror)/
        ""
      ]
      [
        "Chrome Safari"
        "Chrome"
      ]
      [
        "KHTML"
        "Konqueror"
      ]
      [
        "Minefield"
        "Firefox"
      ]
      [
        "Navigator"
        "Netscape"
      ]
    ]) else a)).toLowerCase()
    $.browser = $.extend((if (not z) then $.browser else {}), c(a, /(camino|chrome|firefox|netscape|konqueror|lynx|msie|opera|safari)/, [], /(camino|chrome|firefox|netscape|netscape6|opera|version|konqueror|lynx|msie|safari)(\/|\s)([a-z0-9\.\+]*?)(\;|dev|rel|\s|$)/))
    $.layout = c(a, /(gecko|konqueror|msie|opera|webkit)/, [
      [
        "konqueror"
        "khtml"
      ]
      [
        "msie"
        "trident"
      ]
      [
        "opera"
        "presto"
      ]
    ], /(applewebkit|rv|konqueror|msie)(\:|\/|\s)([a-z0-9\.]*?)(\;|\)|\s)/)
    $.os = name: (/(win|mac|linux|sunos|solaris|iphone)/.exec(navigator.platform.toLowerCase()) or [u])[0].replace("sunos", "solaris")
    unless z
      $("html").addClass [
        $.os.name
        $.browser.name
        $.browser.className
        $.layout.name
        $.layout.className
      ].join(" ")
    return

  $.browserTest navigator.userAgent
  return
) jQuery

processMessage = (s) ->
  p = s.split("|")
  if p.length is 2
    alert p[1]  if p[0] is "Alert"
    document.location.href = p[1]  if p[0] is "Redirect"
    if p[0] is "Function"
      v = p[1].split(",")
      IAVResult v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9], v[10], v[11], v[12], v[13], v[14], v[15], v[16], v[17], v[18], v[19], v[20], v[21]  if v.length is 22
    IAVResultJSON p[1]  if p[0] is "JSON"
  return
(($) ->
  g = undefined
  d = undefined
  j = 1
  a = undefined
  b = this
  f = not 1
  h = "postMessage"
  e = "addEventListener"
  c = undefined
  i = b[h] and not $.browser.opera
  $[h] = (k, l, m) ->
    return  unless l
    k = (if typeof k is "string" then k else $.param(k))
    m = m or parent
    if i
      m[h] k, l.replace(/([^:]+:\/\/[^\/]+).*/, "$1")
    else
      m.location = l.replace(/#.*$/, "") + "#" + (+new Date) + (j++) + "&" + k  if l
    return

  $.receiveMessage = c = (l, m, k) ->
    if i
      if l
        a and c()
        a = (n) ->
          return f  if (typeof m is "string" and n.origin isnt m) or ($.isFunction(m) and m(n.origin) is f)
          l n
          return
      if b[e]
        b[(if l then e else "removeEventListener")] "message", a, f
      else
        b[(if l then "attachEvent" else "detachEvent")] "onmessage", a
    else
      g and clearInterval(g)
      g = null
      if l
        k = (if typeof m is "number" then m else (if typeof k is "number" then k else 100))
        g = setInterval(->
          o = document.location.hash
          n = /^#?\d+&/
          if o isnt d and n.test(o)
            d = o
            l data: o.replace(n, "")
          return
        , k)
    return

  return
) jQuery


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
