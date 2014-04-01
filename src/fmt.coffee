
{ classOf, isClass } = require 'classof'


# -----------------------------------------------------------------------------

getString = (obj) ->
  objClass = classOf(obj)

  if objClass is "Undefined" or objClass is "Null"
    return objClass.toLowerCase()

  else if typeof obj is "number" or typeof obj is "boolean"
    return obj.toString()

  else if typeof obj is "string"
    return obj

  else if typeof obj
   return "[ " + [].map.call(obj, String).join(", ") + " ]"  if Array.isArray(obj)
  String obj


# -----------------------------------------------------------------------------


replaceEach = (items...) ->
  (val) -> val = val.replace(match, subst) for match, subst in items


htmlEscape = replaceEach([/&/g, '&amp;'], [/</g, '&lt;'], [/</g, '&lt;']);

formatting_operators =
  enc: encodeURIComponent
  dec: decodeURIComponent

  dir: (obj) ->
    util.inspect obj,
      depth: 2
      colors: false

  h: (s) ->
    s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/</g, '&lt;')

  t: (s) ->
    s.trim()


# -----------------------------------------------------------------------------


doubleBraceRep = replaceEach([ /\{\{/g, String.fromCharCode(0) ], [ /\}\}/g, String.fromCharCode(1) ]);
doubleBraceRest = replaceEach([ /\x00/g, '{' ], [ /\x01/g, '}' ])


formatSpecRegex = /\{([^!}]+)(?:!([a-z]+))?\}/g;
arrayIndexRegex = /\[(-?\w+)\]/g;


###
Simple string substution function.

fmt('x={0}, y={1}', 12, 4) -> 'x=12, y=4'
fmt('x={x}, y={y}', { x: 12, y: 4 }) -> 'x=12, y=4'
fmt('x={x}, y={{moo}}', { x: 12, y: 4 }) -> 'x=12, y={moo}'
fmt('{x}: {y.thing}', { x: 'foo', y: { thing: 'bar' }}) -> 'foo: bar'
fmt('{x}: {y.a[1]}', { x: 'foo', y: { thing: 'bar', a: [6, 7] }}) -> 'foo: 7'
fmt('{0[2]}, {0[-2]}', [{ x: 12, y: 4 }, 7, 120, 777, 999]) -> '120, 777'
fmt('{0[-5].y}', [{ x: 12, y: 4 }, 7, 120, 777, 999]) -> '4'
fmt('{a[-5].x}', {a: [{ x: 12, y: 4 }, 7, 120, 777, 999]}) -> '12'

@param {String} format
@param {Object|Object+} data
@return {String}
###
fmt = exports.fmt = (format, items...) ->
  data = if items.length is 1 then (data[0] = items[0]) else items

  #data = (if arguments_.length is 2 and typeof data is "object" and data.constructor isnt Array then data else [].slice.call(arguments_, 1))
  #console.log('path="%s" (%s), data=%s', path, p.toSource(), data.toSource());

  format = doubleBraceRep format

  res = format.replace formatSpecRegex, (match, path, oper) ->
    try
      path_props = path.replace(arrayIndexRegex, '.$1').split('.')

      value = path_props.reduce((o, n) ->
        (if o.slice and not isNaN(n) then o.slice(n).shift() else o[n])
      , data)
      value = formatting_operators[oper](value)  if oper and formatting_operators[oper]
      return String(value)
    catch ex
      return match
    return

  res = doubleBraceRest res
  res
