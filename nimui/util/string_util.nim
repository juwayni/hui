import strutils, re, tables, math, ../locale/formats, ./math_util, ../util/variant

type
  StringUtil* = object

proc uncapitalizeFirstLetter*(s: string): string =
  if s.len == 0: return s
  return s[0..0].toLowerAscii() & s[1..^1]

proc capitalizeFirstLetter*(s: string): string =
  if s.len == 0: return s
  return s[0..0].toUpperAscii() & s[1..^1]

proc capitalizeDelim*(s: string, d: string): string =
  var r = s
  var n = r.find(d)
  while n != -1:
    let before = r[0 ..< n]
    let after = r[n + 1 .. ^1]
    r = before & capitalizeFirstLetter(after)
    n = r.find(d, n + 1)
  return r

proc capitalizeHyphens*(s: string): string =
  return capitalizeDelim(s, "-")

proc toDashes*(s: string, toLower: bool = true): string =
  var res = s.replace(re"([a-zA-Z])(?=[A-Z])", "$1-")
  if toLower:
    res = res.toLowerAscii()
  return res

proc splitOnCapitals*(s: string, toLower: bool = true): seq[string] =
  return toDashes(s, toLower).split("-")

proc replaceVars*(s: string, params: Table[string, Variant]): string =
  var res = s
  for k, v in params:
    res = res.replace("${" & k & "}", v.toString())
  return res

proc rpad*(s: string, count: int, c: string = " "): string =
  var res = s
  for i in 0 ..< count:
    res.add(c)
  return res

proc padDecimal*(v: float, precision: int): string =
  var s = $v
  if precision <= 0:
    return s

  var n = s.find('.')
  if n == -1:
    n = s.len
    s.add('.')

  let currentPrecision = s.len - n - 1
  let delta = precision - currentPrecision

  return rpad(s, delta, "0")

proc countTokens*(s: string, token: string): int =
  if s == "": return 0
  return s.split(token).len - 1

const THOUSAND = 1000.0
const MILLION = THOUSAND * THOUSAND
const BILLION = MILLION * THOUSAND

proc standardNotationSuffix*(n: float): string =
  let a = abs(n)
  if a >= 0 and a < THOUSAND: return ""
  elif a >= THOUSAND and a < MILLION: return "K"
  elif a >= MILLION and a < BILLION: return "M"
  else: return "B"

proc valueForSuffix*(n: float, suffix: string): float =
  case suffix:
    of "K": return n / THOUSAND
    of "M": return n / MILLION
    of "B": return n / BILLION
    else: return n

proc formatThousands*(s: string): string =
  var res = ""
  var count = 0
  for i in countdown(s.len - 1, 0):
    if count > 0 and count mod 3 == 0:
      res = gFormats.thousandsSeparator & res
    res = s[i] & res
    inc count
  return res

proc formatNumber*(n: float, precision: int = 0, standardNotation: bool = true, includeSpace: bool = false): string =
  var s = ""
  if standardNotation:
    let suffix = standardNotationSuffix(n)
    var i = valueForSuffix(n, suffix)

    var finalSuffix = suffix
    if finalSuffix != "" and includeSpace:
      finalSuffix = " " & finalSuffix

    if finalSuffix != "":
      i = math_util.round(i, precision)
      s = $i
      var p = s.find('.')
      if p == -1 and precision > 0:
        p = s.len
        s.add(gFormats.decimalSeparator)

      let targetLen = if p == -1: s.len else: p + precision + 1
      while s.len < targetLen:
        s.add('0')
    else:
      s = $i

    s.add(finalSuffix)
  else:
    let s_orig = $n
    let dotIdx = s_orig.find('.')
    if dotIdx == -1:
      s = formatThousands(s_orig)
    else:
      let integerPart = s_orig[0 ..< dotIdx]
      let decimalPart = s_orig[dotIdx + 1 .. ^1]
      s = formatThousands(integerPart) & gFormats.decimalSeparator & decimalPart

  return s

proc formatNumberForStep*(n: float, step: float): string =
  let suffix = standardNotationSuffix(n)
  let stepValueForSuffix = valueForSuffix(step, suffix)
  let precision = math_util.precision(stepValueForSuffix)
  return formatNumber(n, precision)

proc isPercentage*(s: string): bool =
  return s.endsWith("%")

proc parseFloatSafe*(s: string): float =
  if s == "": return 0.0
  var actual = s
  if actual.endsWith("%"):
    actual = actual[0 .. ^2]
  try:
    return parseFloat(actual)
  except:
    return 0.0
