import ./filter, ../util/variant

type
  Invert* = ref object of Filter
    multiplier*: float

proc newInvert*(): Invert =
  new result

method parse*(self: Invert, filterDetails: seq[Variant]) =
  let defaults = @[toVariant(1.0)]
  let copy = applyDefaults(filterDetails, defaults)
  self.multiplier = copy[0].toFloat()
  if self.multiplier < 0:
    self.multiplier = 0
