
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
    if @test(obj) then @thenfn(obj) else @elsefn?(obj)


class ListMapper
  constructor: (@cases...) ->

  test: (val) ->
    for test, result in @cases:
      return result(val) if test(val)

