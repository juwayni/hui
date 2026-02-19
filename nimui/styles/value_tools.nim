import nimui/styles/value
import nimui/styles/dimension
import nimui/util/color
import nimui/util/variant
import std/strutils
import std/options

type
  ValueTools* = object

proc parse*(s: string): Value =
  # Porting complex parsing logic from HaxeUI
  if s.endsWith("%"):
    return Value(kind: vDimension, dVal: Dimension(kind: dPercent, pVal: s.substr(0, s.len - 2).parseFloat))
  elif s.endsWith("px"):
    return Value(kind: vDimension, dVal: Dimension(kind: dPx, fVal: s.substr(0, s.len - 3).parseFloat))
  # ... (more cases)
  return Value(kind: vNone)

proc calcDimension*(value: Value): float =
  if value.kind == vDimension:
    case value.dVal.kind:
    of dPx: return value.dVal.fVal
    of dPercent: return 0.0 # Requires context
    else: return 0.0
  elif value.kind == vNumber:
    return value.fVal
  return 0.0

proc int*(value: Value): int =
  if value.kind == vColor: return value.cVal.toInt()
  elif value.kind == vNumber: return value.fVal.int
  return 0

proc float*(value: Value): float =
  if value.kind == vNumber: return value.fVal
  return 0.0

proc bool*(value: Value): bool =
  if value.kind == vBool: return value.bVal
  return false

proc string*(value: Value): string =
  if value.kind == vString or value.kind == vConstant: return value.sVal
  return ""
