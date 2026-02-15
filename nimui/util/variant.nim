import times
import pixie
import strutils
import math

type
  VariantKind* = enum
    vkNull, vkInt, vkFloat, vkString, vkBool, vkArray, vkComponent, vkDataSource, vkDate, vkImageData

  Variant* = object
    case kind*: VariantKind
    of vkNull: discard
    of vkInt: i*: int
    of vkFloat: f*: float
    of vkString: s*: string
    of vkBool: b*: bool
    of vkArray: a*: seq[Variant]
    of vkComponent: c*: RootRef
    of vkDataSource: ds*: RootRef
    of vkDate: d*: float
    of vkImageData: img*: Image

converter toVariant*(i: int): Variant = Variant(kind: vkInt, i: i)
converter toVariant*(f: float): Variant = Variant(kind: vkFloat, f: f)
converter toVariant*(s: string): Variant = Variant(kind: vkString, s: s)
converter toVariant*(b: bool): Variant = Variant(kind: vkBool, b: b)
converter toVariant*(img: Image): Variant = Variant(kind: vkImageData, img: img)

proc toString*(v: Variant): string =
  case v.kind:
    of vkNull: return ""
    of vkInt: return $v.i
    of vkFloat: return $v.f
    of vkString: return v.s
    of vkBool: return $v.b
    of vkArray: return "Array"
    of vkComponent: return "Component"
    of vkDataSource: return "DataSource"
    of vkDate: return $v.d
    of vkImageData: return "ImageData"

proc toInt*(v: Variant): int =
  case v.kind:
    of vkInt: return v.i
    of vkFloat: return v.f.int
    of vkString:
      try: return v.s.parseInt except: return 0
    else: return 0

proc toFloat*(v: Variant): float =
  case v.kind:
    of vkInt: return v.i.float
    of vkFloat: return v.f
    of vkString:
      try: return v.s.parseFloat except: return 0.0
    else: return 0.0

proc toBool*(v: Variant): bool =
  case v.kind:
    of vkBool: return v.b
    of vkString: return v.s == "true"
    else: return false

proc isNumber*(v: Variant): bool =
  v.kind in {vkInt, vkFloat}
