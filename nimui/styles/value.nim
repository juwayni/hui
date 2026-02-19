import nimui/styles/dimension
import nimui/constants/unit_time
import nimui/util/variant

type
  ValueKind* = enum
    vkString, vkNumber, vkBool, vkDimension, vkColor, vkCall, vkConstant, vkComposite, vkTime, vkNone

  Value* = object
    case kind*: ValueKind
    of vkString: vString*: string
    of vkNumber: vNumber*: float
    of vkBool: vBool*: bool
    of vkDimension: vDimension*: Dimension
    of vkColor: vColor*: int
    of vkCall:
      f*: string
      vl*: seq[Value]
    of vkConstant: vConstant*: string
    of vkComposite: vlComp*: seq[Value]
    of vkTime:
      vTime*: float
      unit*: UnitTime
    of vkNone: discard

proc toVariant*(v: Value): Variant =
  case v.kind:
    of vkString: return toVariant(v.vString)
    of vkNumber: return toVariant(v.vNumber)
    of vkBool: return toVariant(v.vBool)
    of vkColor: return toVariant(v.vColor)
    of vkDimension: return toVariant(v.vDimension)
    else: return toVariant(nil)
