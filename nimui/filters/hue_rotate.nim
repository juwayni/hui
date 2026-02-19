import ./filter, ../util/variant

type
  HueRotate* = ref object of Filter
    angleDegree*: float

proc newHueRotate*(): HueRotate =
  new result

method parse*(self: HueRotate, filterDetails: seq[Variant]) =
  let defaults = @[toVariant(1.0)]
  let copy = applyDefaults(filterDetails, defaults)
  self.angleDegree = copy[0].toFloat()
