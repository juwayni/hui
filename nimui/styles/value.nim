import nimui/styles/dimension
import nimui/constants/unit_time
import nimui/util/color

type
  ValueKind* = enum
    vkString, vkNumber, vkBool, vkDimension, vkColor, vkCall, vkConstant, vkComposite, vkTime, vkNone

  Value* = object
    case kind*: ValueKind
    of vkString: stringValue*: string
    of vkNumber: numberValue*: float
    of vkBool: boolValue*: bool
    of vkDimension: dimensionValue*: Dimension
    of vkColor: colorValue*: Color
    of vkCall:
      callName*: string
      callArgs*: seq[Value]
    of vkConstant: constantValue*: string
    of vkComposite: compositeValues*: seq[Value]
    of vkTime:
      timeValue*: float
      timeUnit*: UnitTime
    of vkNone: discard

proc VString*(v: string): Value = Value(kind: vkString, stringValue: v)
proc VNumber*(v: float): Value = Value(kind: vkNumber, numberValue: v)
proc VBool*(v: bool): Value = Value(kind: vkBool, boolValue: v)
proc VDimension*(v: Dimension): Value = Value(kind: vkDimension, dimensionValue: v)
proc VColor*(v: Color): Value = Value(kind: vkColor, colorValue: v)
proc VNone*(): Value = Value(kind: vkNone)
