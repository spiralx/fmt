

# -----------------------------------------------------------------------------

realToString = Object::toString
realToStringRegex = /^\[object\s(.*)\]$/

###
classOf(obj) returns the name of the internal [[Class]] property of obj,
which is guaranteed to be part of the output of Object.prototype.toString
when called on an object.

The only tweak is to ensure that the result is capitalised - this is because
the Node.js process and global objects are the only objects that return a
lower-cased name, so this function will change them to Process and Global
respectively to be consistent.

@param  {Object?} object
@return {String}
###
classOf = exports.classOf = (obj) ->
  c = realToString.call(obj).match(realToStringRegex)[1]
  c[0].toUpperCase() + c.substr(1)


###
Check whether the class of obj is one of the supplied names.

@param {Object} obj
@param {String+} names
@return {Boolean}
###
isClass = exports.isClass = (obj, names...) -> classOf(obj) in names


