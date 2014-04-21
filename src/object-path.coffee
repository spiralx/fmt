
{ classOf, isClass } = require './classof'
{ findall, reduce } = require './utils'


# -----------------------------------------------------------------------------

exports.PathElement = class PathElement
  constructor: (@key, @depth = 0) ->
    if (classOf @depth) isnt 'Number' or @depth < 0
      throw new TypeError "Depth must be zero or a positive integer, not #{@depth} (#{typeof @depth})"

  pathExpr: -> @key

  toString: -> "#{@constructor.name}(k: \"#{@pathExpr()}\", d: #{@depth})"


# -----------------------------------------------------------------------------

exports.PropertyElement = class PropertyElement extends PathElement
  constructor: (key, depth = 0) ->
    super key, depth

    if not ((isClass @key, 'String') and @key.match /[a-z_$][a-z0-9_]*/i)
      throw new TypeError "Key must be a valid property name, not #{@key} (#{typeof @key})"


  resolve: (obj) ->
    obj[@key] if obj? and obj.hasOwnProperty @key
    # console.log "key: #{@key}, r: #{classOf r}, obj: #{classOf obj} obj.has: #{obj.hasOwnProperty @key} obj.keys: #{(Object.keys obj).join(',')}"
    # console.dir r

  pathExpr: -> ".#{@key}"



# -----------------------------------------------------------------------------

exports.IndexElement = class IndexElement extends PathElement
  constructor: (index = 0, depth = 0) ->
    if isNaN index
      throw new TypeError "Key must be a valid array index, not #{index} (#{typeof index})"
    super (parseInt index), depth

  resolve: (obj) ->
    if isClass obj, 'Array'
      realIndex = if @key >= 0 then @key else obj.length + @key
      obj[realIndex] if 0 <= realIndex < obj.length

  pathExpr: -> "[#{@key}]"


# -----------------------------------------------------------------------------

exports.ObjectPath = class ObjectPath
  constructor: (@path = '.') ->
    @elems = if @path is '.'
      []
    else if not isNaN @path
      [ new IndexElement @path ]
    else
      re = ///
          ^([a-z$][a-z0-9_$]*)
        | \.([a-z$][a-z0-9_$]*)
        | \[(-?\d+)\]
      ///g

      for m, i in findall re, @path
        switch
          when m[1]? then new PropertyElement m[1], i
          when m[2]? then new PropertyElement m[2], i
          when m[3]? then new IndexElement m[3], i

  Object.defineProperty @prototype, 'pathExpr', get: -> if @elems.length then (elem.pathExpr() for elem in @elems).join '' else '.'

  toString: ->
    ((i + ': ' + e.toString()) for e, i in @elems).join ', '

  resolve: (obj) ->
    #console.dir obj
    #console.log @toString()
    reduce @elems, obj, ((cur, elem) -> elem.resolve cur)

