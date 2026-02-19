import ./filter, ../util/variant

type
  Blur* = ref object of Filter
    amount*: float

proc newBlur*(): Blur =
  new result

method parse*(self: Blur, filterDetails: seq[Variant]) =
  let defaults = @[toVariant(1.0)]
  let copy = applyDefaults(filterDetails, defaults)
  self.amount = copy[0].toFloat()
