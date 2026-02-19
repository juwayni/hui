import ./filter, ../util/variant

type
  Grayscale* = ref object of Filter
    amount*: float

proc newGrayscale*(): Grayscale =
  new result

method parse*(self: Grayscale, filterDetails: seq[Variant]) =
  let defaults = @[toVariant(100.0)]
  let copy = applyDefaults(filterDetails, defaults)
  self.amount = copy[0].toFloat()
