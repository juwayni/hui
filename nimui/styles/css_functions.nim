import nimui/styles/value
import nimui/styles/value_tools
import nimui/util/color
import nimui/util/variant
import std/tables
import std/math

type
  CssFunction* = proc(vl: seq[Value]): Variant {.gcsafe.}

var cssFunctions = initTable[string, CssFunction]()

proc registerCssFunction*(name: string, fn: CssFunction) =
  cssFunctions[name] = fn

proc hasCssFunction*(name: string): bool =
  return cssFunctions.hasKey(name)

proc getCssFunction*(name: string): CssFunction =
  return cssFunctions[name]

# Standard CSS functions
proc rgb*(vl: seq[Value]): Variant =
  let r = int(vl[0])
  let g = int(vl[1])
  let b = int(vl[2])
  return toVariant(color.fromComponents(r, g, b, 255).toInt())

proc min*(vl: seq[Value]): Variant =
  var m = Inf
  for v in vl:
    let d = calcDimension(v)
    if d < m: m = d
  return toVariant(m)

proc max*(vl: seq[Value]): Variant =
  var m = -Inf
  for v in vl:
    let d = calcDimension(v)
    if d > m: m = d
  return toVariant(m)
