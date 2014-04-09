
{ classOf, isClass } = require('./classof')


# -----------------------------------------------------------------------------


passAny = (tests...) ->
  (val) -> tests.some((test) -> test(val))

passAll = (tests...) ->
  (val) -> tests.every((test) -> test(val))

passNone = (tests...) ->
  (val) -> not tests.some((test) -> test(val))


# -----------------------------------------------------------------------------


class IfThen
  constructor: (@test, @thenfn, @elsefn) ->

  evaluate: (obj) ->
    if @test obj then @thenfn obj else @elsefn? obj


# -----------------------------------------------------------------------------

findall = exports.findall = (regex, str) ->
  regex.lastIndex = 0
  m while m = regex.exec str


partial = (func, a...) ->
  (b...) -> func a..., b...


compose = (func1, func2) ->
  (args...) -> func1 func2 args...


reduce = exports.reduce = (array, combine, base) ->
  base = base ? array.shift()
  for element in array
    base = combine base, element
  base


# -----------------------------------------------------------------------------


getProperty = exports.getProperty = (obj, key) ->
  if obj? and key?
    if isClass obj, 'Array' and not isNaN key
      return obj[parseInt key]
    if obj.hasOwnProperty key
      return obj[key]
  ''



# -----------------------------------------------------------------------------


replaceEach = exports.replaceEach = (items...) ->
  (val) ->
    for [match, subst] in items
      val = val.replace match, subst
    val


htmlEscape = exports.htmlEscape = replaceEach [/&/g, '&amp;'], [/>/g, '&gt;'], [/</g, '&lt;']
