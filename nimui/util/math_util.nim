import math

const MAX_INT* = 2147483647
const MIN_INT* = -2147483648
const MAX_FLOAT_DIFFERENCE* = 0.0000001

proc distance*(x1, y1, x2, y2: float): float =
  sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))

proc round*(v: float, precision: int = 0): float =
  let e = pow(10.0, precision.float)
  return round(v * e) / e

proc precision*(v: float): int =
  var e = 1.0
  var p = 0
  while abs((round(v * e) / e) - v) > MAX_FLOAT_DIFFERENCE and p < 10:
    e *= 10.0
    p += 1
  return p

proc fmodulo*(v1, v2: float): float =
  if v1.classify notin {fcNormal, fcZero}: return NaN
  if v2.classify notin {fcNormal, fcZero}: return NaN
  let p = max(precision(v1), precision(v2))
  let e = pow(10.0, p.float)
  let i1 = round(v1 * e)
  let i2 = round(v2 * e)
  return round((i1.int mod i2.int).float / e, p)

proc roundToNearest*(v, n: float): float =
  if v.classify notin {fcNormal, fcZero}: return NaN
  if n.classify notin {fcNormal, fcZero}: return NaN
  let p = max(precision(v), precision(n))
  let inv = 1.0 / n
  return round(round(v * inv) / inv, p)

proc clamp*(v, minVal, maxVal: float): float =
  if v.classify == fcNaN: return minVal
  var res = v
  if res < minVal: res = minVal
  elif res > maxVal: res = maxVal
  return res

proc wrapCircular*(v, maxVal: float): float =
  var res = v mod maxVal
  if res < 0:
    res += maxVal
  return res
