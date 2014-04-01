
classof = require('./classof')


# -----------------------------------------------------------------------------


PrettyPrinter = ->
  @ppNestLevel_ = 0


###
Formats a value in a nice, human-readable string.

@param value
###
PrettyPrinter::format = (value) ->
  @ppNestLevel_++
  try
    if value is `undefined`
      @emitScalar "undefined"
    else if value is null
      @emitScalar "null"
    else if value is getGlobal()
      @emitScalar "<global>"
    else if value.jasmineToString
      @emitScalar value.jasmineToString()
    else if typeof value is "string"
      @emitString value
    else if isSpy(value)
      @emitScalar "spy on " + value.identity
    else if value instanceof RegExp
      @emitScalar value.toString()
    else if typeof value is "function"
      @emitScalar "Function"
    else if typeof value.nodeType is "number"
      @emitScalar "HTMLNode"
    else if value instanceof Date
      @emitScalar "Date(" + value + ")"
    else if value.__Jasmine_been_here_before__
      @emitScalar "<circular reference: " + ((if isArray_(value) then "Array" else "Object")) + ">"
    else if isArray_(value) or typeof value is "object"
      value.__Jasmine_been_here_before__ = true
      if isArray_(value)
        @emitArray value
      else
        @emitObject value
      delete value.__Jasmine_been_here_before__
    else
      @emitScalar value.toString()
  finally
    @ppNestLevel_--
  return

PrettyPrinter::iterateObject = (obj, fn) ->
  for property of obj
    continue  unless obj.hasOwnProperty(property)
    continue  if property is "__Jasmine_been_here_before__"
    fn property, (if obj.__lookupGetter__ then (obj.__lookupGetter__(property) isnt `undefined` and obj.__lookupGetter__(property) isnt null) else false)
  return

PrettyPrinter::emitArray = unimplementedMethod_
PrettyPrinter::emitObject = unimplementedMethod_
PrettyPrinter::emitScalar = unimplementedMethod_
PrettyPrinter::emitString = unimplementedMethod_
StringPrettyPrinter = ->
  PrettyPrinter.call this
  @string = ""
  return

util.inherit StringPrettyPrinter, PrettyPrinter
StringPrettyPrinter::emitScalar = (value) ->
  @append value
  return

StringPrettyPrinter::emitString = (value) ->
  @append "'" + value + "'"
  return

StringPrettyPrinter::emitArray = (array) ->
  if @ppNestLevel_ > MAX_PRETTY_PRINT_DEPTH
    @append "Array"
    return
  @append "[ "
  i = 0

  while i < array.length
    @append ", "  if i > 0
    @format array[i]
    i++
  @append " ]"
  return

StringPrettyPrinter::emitObject = (obj) ->
  if @ppNestLevel_ > MAX_PRETTY_PRINT_DEPTH
    @append "Object"
    return
  self = this
  @append "{ "
  first = true
  @iterateObject obj, (property, isGetter) ->
    if first
      first = false
    else
      self.append ", "
    self.append property
    self.append " : "
    if isGetter
      self.append "<getter>"
    else
      self.format obj[property]
    return

  @append " }"
  return

StringPrettyPrinter::append = (value) ->
  @string += value
  return
