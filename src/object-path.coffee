
{ isClass } = require './classof'
{ findall, reduce } = require './utils'


# -----------------------------------------------------------------------------

class PathElement
  constructor: (@key, @depth) ->

  pathExpr: -> @key


class PropertyElement extends PathElement
  resolve: (obj) ->
    obj[@key] if obj?hasOwnProperty @key

  pathExpr: -> ".#{@key}"


class IndexElement extends PathElement
  constructor: (key, depth) ->
    super key, depth
    @index = parseInt key

  resolve: (obj) ->
    if isClass obj, 'Array'
      realIndex = if @index > 0 then @index else obj.length + @index
      obj[realIndex] if 0 <= realIndex < obj.length

  pathExpr: -> "[#{@key}]"


exports.ObjectPath = class ObjectPath
  constructor: (@path) ->
    if @path and not isNaN @path
      @elems = [ new IndexElement @path, 0 ]

    else
      re = ///
          ^([a-z$][a-z0-9_$]*)
        | \.([a-z$][a-z0-9_$]*)
        | \[(-?\d+)\]
      ///g

      @elems = for m, i in findall re, @path
        switch
          when m[1]? then new PropertyElement m[1], i
          when m[2]? then new PropertyElement m[2], i
          when m[3]? then new IndexElement m[3], i

  Object.defineProperty @prototype, 'pathExpr', get: -> (elem.pathExpr() for elem in @elems).join ''

  resolve: (obj) ->
    reduce @elems, (cur, elem) -> elem.resolve obj, obj

