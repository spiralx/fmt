
{ classOf, isClass } = require('./classof')


# -----------------------------------------------------------------------------

# getOptions = (val) -> if typeof val is 'String' then val.split(' ') else val


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


# class ListMapper
#   constructor: (@cases...) ->

#   test: (val) ->
#     for test, result in @cases:
#       if test val
#         return true
#     false


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
