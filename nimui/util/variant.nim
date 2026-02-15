import nimui/core/component
import nimui/backend/image_data

type
  VariantType* = enum
    vtInt, vtFloat, vtString, vtBool, vtArray, vtComponent, vtImageData, vtNone

  Variant* = object
    case kind*: VariantType
    of vtInt: intVal*: int
    of vtFloat: floatVal*: float
    of vtString: stringVal*: string
    of vtBool: boolVal*: bool
    of vtArray: arrayVal*: seq[Variant]
    of vtComponent: componentVal*: Component
    of vtImageData: imageVal*: ImageData
    of vtNone: discard

proc VNone*(): Variant = Variant(kind: vtNone)
proc VString*(v: string): Variant = Variant(kind: vtString, stringVal: v)
proc VInt*(v: int): Variant = Variant(kind: vtInt, intVal: v)
proc VFloat*(v: float): Variant = Variant(kind: vtFloat, floatVal: v)
proc VBool*(v: bool): Variant = Variant(kind: vtBool, boolVal: v)

proc toDynamic*(v: Variant): RootRef =
  # Very simplified for now
  return nil
