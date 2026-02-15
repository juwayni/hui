type
  DimensionKind* = enum
    dkPercent, dkPx, dkVw, dkVh, dkRem, dkCalc

  Dimension* = object
    case kind*: DimensionKind
    of dkPercent, dkPx, dkVw, dkVh, dkRem: floatValue*: float
    of dkCalc: stringValue*: string

proc Percent*(v: float): Dimension = Dimension(kind: dkPercent, floatValue: v)
proc Px*(v: float): Dimension = Dimension(kind: dkPx, floatValue: v)
proc Vw*(v: float): Dimension = Dimension(kind: dkVw, floatValue: v)
proc Vh*(v: float): Dimension = Dimension(kind: dkVh, floatValue: v)
proc Rem*(v: float): Dimension = Dimension(kind: dkRem, floatValue: v)
proc Calc*(v: string): Dimension = Dimension(kind: dkCalc, stringValue: v)
