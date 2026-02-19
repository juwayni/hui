import ./filter, ../util/variant

type
  Outline* = ref object of Filter
    color*: int
    size*: int

proc newOutline*(): Outline =
  new result

method parse*(self: Outline, filterDetails: seq[Variant]) =
  let defaults = @[toVariant(0), toVariant(1)]
  let copy = applyDefaults(filterDetails, defaults)
  self.color = copy[0].toInt()
  self.size = copy[1].toInt()
