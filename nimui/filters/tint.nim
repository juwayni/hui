import ./filter, ../util/variant

type
  Tint* = ref object of Filter
    color*: int
    amount*: float

proc newTint*(): Tint =
  new result

method parse*(self: Tint, filterDetails: seq[Variant]) =
  let defaults = @[toVariant(0), toVariant(1.0)]
  let copy = applyDefaults(filterDetails, defaults)
  self.color = copy[0].toInt()
  self.amount = copy[1].toFloat()
  if self.amount < 0: self.amount = 0
  elif self.amount > 1: self.amount = 1
