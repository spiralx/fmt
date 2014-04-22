
{ classOf, isClass } = require('./classof')



# -----------------------------------------------------------------------------

findall = exports.findall = (regex, str) ->
  regex.lastIndex = 0
  m while m = regex.exec str


partial = exports.partial = (func, a...) ->
  (b...) -> func a..., b...


compose = (func1, func2) ->
  (args...) -> func1 func2 args...


###
Functional version of Array.reduce

@param {Array} array
@param {Object?} base
@param {Function} combine
@return {Object}
###
reduce = exports.reduce = (array, base, combine) ->
  [base, combine] = [array.shift(), base] unless combine?
  array.reduce combine, base


# -----------------------------------------------------------------------------

extend = (dest, src) ->
  dest[key] = value for key, value of src
  dest


###
Takes a series of [name, value] arrays and returns a new
object with those properties.

@param {Array*} items
@return {Object}
###
dict = exports.dict = (items...) ->
  d = {}
  for [name, value] in items
    d[name] = value
  d


###
Combines objects by overwriting the first object's properties with the
properties of each successive object passed, and returning the first object.

@param {Object+} objs
@return {Object}
###
update = exports.update = (objs...) ->
  reduce objs, extend


###
Combines objects by overwriting a new object's properties with the
properties of each object passed and returning it.

@param {Object*} objs
@return {Object}
###
merge = exports.merge = (objs...) ->
  update {}, objs...


# -----------------------------------------------------------------------------

getProperty = exports.getProperty = (obj, key) ->
  if obj? and key?
    if isClass obj, 'Array' and not isNaN key
      return obj[parseInt key]
    if obj.hasOwnProperty key
      return obj[key]
  ''



# -----------------------------------------------------------------------------

replacer = exports.replacer = (items...) ->
  (val) ->
    reduce items, val, (cur, next) -> cur.replace next...


# -----------------------------------------------------------------------------

HTML_ESCAPES = [
  [ /&/g, '&amp;' ]
  [ />/g, '&gt;' ]
  [ /</g, '&lt;' ]
]

HTML_DECODE_RE = /&[a-z]*;|&#[0-9]*;/gi

HTML_ENTITIES =
  '&amp;': 38
  '&gt;': 62
  '&lt;': 60
  '&quot;': 34
  '&apos;': 39
  '&acute;': 180
  '&cedil;': 184
  '&circ;': 710
  '&macr;': 175
  '&middot;': 183
  '&tilde;': 732
  '&uml;': 168
  '&Aacute;': 193
  '&aacute;': 225
  '&Acirc;': 194
  '&acirc;': 226
  '&AElig;': 198
  '&aelig;': 230
  '&Agrave;': 192
  '&agrave;': 224
  '&Aring;': 197
  '&aring;': 229
  '&Atilde;': 195
  '&atilde;': 227
  '&Auml;': 196
  '&auml;': 228
  '&Ccedil;': 199
  '&ccedil;': 231
  '&Eacute;': 201
  '&eacute;': 233
  '&Ecirc;': 202
  '&ecirc;': 234
  '&Egrave;': 200
  '&egrave;': 232
  '&ETH;': 208
  '&eth;': 240
  '&Euml;': 203
  '&euml;': 235
  '&Iacute;': 205
  '&iacute;': 237
  '&Icirc;': 206
  '&icirc;': 238
  '&Igrave;': 204
  '&igrave;': 236
  '&Iuml;': 207
  '&iuml;': 239
  '&Ntilde;': 209
  '&ntilde;': 241
  '&Oacute;': 211
  '&oacute;': 243
  '&Ocirc;': 212
  '&ocirc;': 244
  '&OElig;': 338
  '&oelig;': 339
  '&Ograve;': 210
  '&ograve;': 242
  '&Oslash;': 216
  '&oslash;': 248
  '&Otilde;': 213
  '&otilde;': 245
  '&Ouml;': 214
  '&ouml;': 246
  '&Scaron;': 352
  '&scaron;': 353
  '&szlig;': 223
  '&THORN;': 222
  '&thorn;': 254
  '&Uacute;': 218
  '&uacute;': 250
  '&Ucirc;': 219
  '&ucirc;': 251
  '&Ugrave;': 217
  '&ugrave;': 249
  '&Uuml;': 220
  '&uuml;': 252
  '&Yacute;': 221
  '&yacute;': 253
  '&yuml;': 255
  '&Yuml;': 376
  '&cent;': 162
  '&curren;': 164
  '&euro;': 8364
  '&pound;': 163
  '&yen;': 165
  '&brvbar;': 166
  '&bull;': 8226
  '&copy;': 169
  '&dagger;': 8224
  '&Dagger;': 8225
  '&frasl;': 8260
  '&hellip;': 8230
  '&iexcl;': 161
  '&image;': 8465
  '&iquest;': 191
  '&lrm;': 8206
  '&mdash;': 8212
  '&ndash;': 8211
  '&not;': 172
  '&oline;': 8254
  '&ordf;': 170
  '&ordm;': 186
  '&para;': 182
  '&permil;': 8240
  '&prime;': 8242
  '&Prime;': 8243
  '&real;': 8476
  '&reg;': 174
  '&rlm;': 8207
  '&sect;': 167
  '&shy;': 173
  '&sup1;': 185
  '&trade;': 8482
  '&weierp;': 8472
  '&bdquo;': 8222
  '&laquo;': 171
  '&ldquo;': 8220
  '&lsaquo;': 8249
  '&lsquo;': 8216
  '&raquo;': 187
  '&rdquo;': 8221
  '&rsaquo;': 8250
  '&rsquo;': 8217
  '&sbquo;': 8218
  '&deg;': 176
  '&divide;': 247
  '&frac12;': 189
  '&frac14;': 188
  '&frac34;': 190
  '&ge;': 8805
  '&le;': 8804
  '&minus;': 8722
  '&sup2;': 178
  '&sup3;': 179
  '&times;': 215
  '&alefsym;': 8501
  '&and;': 8743
  '&ang;': 8736
  '&asymp;': 8776
  '&cap;': 8745
  '&cong;': 8773
  '&cup;': 8746
  '&empty;': 8709
  '&equiv;': 8801
  '&exist;': 8707
  '&fnof;': 402
  '&forall;': 8704
  '&infin;': 8734
  '&int;': 8747
  '&isin;': 8712
  '&lang;': 9001
  '&lceil;': 8968
  '&lfloor;': 8970
  '&lowast;': 8727
  '&micro;': 181
  '&nabla;': 8711
  '&ne;': 8800
  '&ni;': 8715
  '&notin;': 8713
  '&nsub;': 8836
  '&oplus;': 8853
  '&or;': 8744
  '&otimes;': 8855
  '&part;': 8706
  '&perp;': 8869
  '&plusmn;': 177
  '&prod;': 8719
  '&prop;': 8733
  '&radic;': 8730
  '&rang;': 9002
  '&rceil;': 8969
  '&rfloor;': 8971
  '&sdot;': 8901
  '&sim;': 8764
  '&sub;': 8834
  '&sube;': 8838
  '&sum;': 8721
  '&sup;': 8835
  '&supe;': 8839
  '&there4;': 8756
  '&Alpha;': 913
  '&alpha;': 945
  '&Beta;': 914
  '&beta;': 946
  '&Chi;': 935
  '&chi;': 967
  '&Delta;': 916
  '&delta;': 948
  '&Epsilon;': 917
  '&epsilon;': 949
  '&Eta;': 919
  '&eta;': 951
  '&Gamma;': 915
  '&gamma;': 947
  '&Iota;': 921
  '&iota;': 953
  '&Kappa;': 922
  '&kappa;': 954
  '&Lambda;': 923
  '&lambda;': 955
  '&Mu;': 924
  '&mu;': 956
  '&Nu;': 925
  '&nu;': 957
  '&Omega;': 937
  '&omega;': 969
  '&Omicron;': 927
  '&omicron;': 959
  '&Phi;': 934
  '&phi;': 966
  '&Pi;': 928
  '&pi;': 960
  '&piv;': 982
  '&Psi;': 936
  '&psi;': 968
  '&Rho;': 929
  '&rho;': 961
  '&Sigma;': 931
  '&sigma;': 963
  '&sigmaf;': 962
  '&Tau;': 932
  '&tau;': 964
  '&Theta;': 920
  '&theta;': 952
  '&thetasym;': 977
  '&upish;': 978
  '&Upsilon;': 933
  '&upsilon;': 965
  '&Xi;': 926
  '&xi;': 958
  '&Zeta;': 918
  '&zeta;': 950
  '&crarr;': 8629
  '&darr;': 8595
  '&dArr;': 8659
  '&harr;': 8596
  '&hArr;': 8660
  '&larr;': 8592
  '&lArr;': 8656
  '&rarr;': 8594
  '&rArr;': 8658
  '&uarr;': 8593
  '&uArr;': 8657
  '&clubs;': 9827
  '&diams;': 9830
  '&hearts;': 9829
  '&spades;': 9824
  '&loz;': 9674
  '&ensp;': 8194
  '&emsp;': 8195
  '&thinsp;': 8201
  '&nbsp;': 160



htmlEncode = exports.htmlEncode = replacer HTML_ESCAPES...

htmlDecode = exports.htmlDecode = (html) ->
  html.replace HTML_DECODE_RE, (m) -> if m[1] is '#' then (String.fromCharCode parseInt m.substr 2) else




FMT_CURRENCY_OPTIONS =
  precision: 2
  requiredPrecision: 2
  integerRequired: false
  decimalSymbol: '.'
  groupSymbol: ','
  groupLength: 3
  showPlus: false


###
Formats currency using pattern

@param {Number?} price
@param {Object?} options - { pattern, decimal, decimalsDelimeter, groupsDelimeter }
@param {Boolean?} showPlus - true (always show '+'or '-'),
                             false (never show '-' even if number is negative)
                             null (show '-' if number is negative)
@return {String}
###
formatCurrency = (price, options) ->
  options = merge FMT_CURRENCY_OPTIONS, format

  prefix = if price < 0 then '-' else if options.showPlus then '+' else ''

  absprice = Math.abs(+price || 0)
  prefix + parseInt absprice.toFixed options.precision


  # j = (j = i.length) > groupLength ? j % groupLength : 0;
  # re = new RegExp("(\\d{" + groupLength + "})(?=\\d)", "g");

  # /**
  #  * replace(/-/, 0) is only for fixing Safari bug which appears
  #  * when Math.abs(0).toFixed() executed on "0" number.
  #  * Result is "0.-0" :(
  #  */
  # var r = (j ? i.substr(0, j) + groupSymbol : "") + i.substr(j).replace(re, "$1" + groupSymbol) + (precision ? decimalSymbol + Math.abs(price - i).toFixed(precision).replace(/-/, 0).slice(2) : "")
  # var pattern = '';
  # if (format.pattern.indexOf('{sign}') == -1) {
  #     pattern = s + format.pattern;
  # } else {
  #     pattern = format.pattern.replace('{sign}', s);
  # }

  # return pattern.replace('%s', r).replace(/^\s\s*/, '').replace(/\s\s*$/, '');

