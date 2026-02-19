import ./filter, ../util/variant

type
  Brightness* = ref object of Filter
    multiplier*: float

proc newBrightness*(): Brightness =
  new result

method parse*(self: Brightness, filterDetails: seq[Variant]) =
  let defaults = @[toVariant(1.0)]
  let copy = applyDefaults(filterDetails, defaults)
  self.multiplier = copy[0].toFloat()
  if self.multiplier < 0:
    self.multiplier = 0
