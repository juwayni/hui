import nimui/util/variant
import std/strutils

type
  ScrollMode* = enum
    Default = "default"
    Normal = "normal"
    Drag = "drag"
    Inertial = "inertial"
    Hybrid = "hybrid"
    Native = "native"

proc scrollModeFromString*(s: string): ScrollMode =
  case s.toLowerAscii():
    of "default": return ScrollMode.Default
    of "normal": return ScrollMode.Normal
    of "drag": return ScrollMode.Drag
    of "inertial": return ScrollMode.Inertial
    of "hybrid": return ScrollMode.Hybrid
    of "native": return ScrollMode.Native
    else:
      raise newException(ValueError, "invalid ScrollMode enum value '" & s & "'")

proc scrollModeFromVariant*(v: Variant): ScrollMode =
  if v.kind == vkNull:
    return ScrollMode.Default
  return scrollModeFromString(v.toString())
