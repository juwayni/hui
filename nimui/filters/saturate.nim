import ./filter, ../util/variant

type
  Saturate* = ref object of Filter
    multiplier*: float

proc newSaturate*(): Saturate =
  new result

method parse*(self: Saturate, filterDetails: seq[Variant]) =
  let defaults = @[toVariant(1.0)]
  let copy = applyDefaults(filterDetails, defaults)
  self.multiplier = copy[0].toFloat()
  if self.multiplier < 0:
    self.multiplier = 0
