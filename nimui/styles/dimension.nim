type
  DimensionKind* = enum
    dkPercent, dkPx, dkVw, dkVh, dkRem, dkCalc

  Dimension* = object
    case kind*: DimensionKind
    of dkPercent: percentValue*: float
    of dkPx: pxValue*: float
    of dkVw: vwValue*: float
    of dkVh: vhValue*: float
    of dkRem: remValue*: float
    of dkCalc: calcValue*: string
