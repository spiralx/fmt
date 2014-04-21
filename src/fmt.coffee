
{ classOf, isClass } = require './classof'
{ replacer, htmlEncode, getProperty } = require './utils'
{ ObjectPath } = require './object-path'


# -----------------------------------------------------------------------------

getString = (obj) ->
  objClass = classOf(obj)

  if objClass is 'Undefined' or objClass is 'Null'
    return objClass.toLowerCase()

  else if typeof obj is 'number' or typeof obj is 'boolean'
    return obj.toString()

  else if typeof obj is 'string'
    return obj

  else if typeof obj
    return '[ ' + [].map.call(obj, String).join(', ') + ' ]'  if Array.isArray(obj)

  String obj


# -----------------------------------------------------------------------------


formatting_operators =
  enc: encodeURIComponent
  dec: decodeURIComponent

  dir: (obj) ->
    util.inspect obj,
      depth: 2
      colors: false

  h: htmlEncode

  t: (s) -> s.trim()


# -----------------------------------------------------------------------------


doubleBraceRep = replacer [ /\{\{/g, String.fromCharCode(0) ], [ /\}\}/g, String.fromCharCode(1) ]
doubleBraceRest = replacer [ /\x00/g, '{' ], [ /\x01/g, '}' ]


formatSpecRegex = /\{([^!}]+)(?:!([a-z]+))?\}/g
arrayIndexRegex = /\[(-?\w+)\]/g


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
  # console.info "'#{format}', #{classOf format}, #{items[0]}, #{classOf items[0]}"
  # console.dir items
  if (classOf format) isnt 'String'
    data = [ format ]
    format = '{0}'
  else if items.length is 1 and not (isClass items[0], 'String Number Date RegExp Function')
    data = items[0]
  else
    data = items

  format = doubleBraceRep format

  # console.log format
  # console.dir data

  res = format.replace formatSpecRegex, (match, path, oper) ->
    try
      objpath = new ObjectPath path

      value = (objpath.resolve data) ? ''
      console.info "path: '#{path}', oper: '#{oper}', objpath: '#{objpath.pathExpr}', value: #{value}"

      if oper and formatting_operators[oper]
        value = formatting_operators[oper] value

      String value

    catch ex
      match

  doubleBraceRest res
