import ./filter, ../util/variant

type
  BoxShadow* = ref object of Filter
    offsetX*: float
    offsetY*: float
    color*: int
    alpha*: float
    blurRadius*: float
    spreadRadius*: float
    inset*: bool

proc newBoxShadow*(): BoxShadow =
  new result

method parse*(self: BoxShadow, filterDetails: seq[Variant]) =
  let defaults = @[toVariant(2.0), toVariant(2.0), toVariant(0), toVariant(0.1), toVariant(1.0), toVariant(0.0), toVariant(false)]
  let copy = applyDefaults(filterDetails, defaults)
  self.offsetX = copy[0].toFloat()
  self.offsetY = copy[1].toFloat()
  self.color = copy[2].toInt()
  self.alpha = copy[3].toFloat()
  self.blurRadius = copy[4].toFloat()
  self.spreadRadius = copy[5].toFloat()
  self.inset = copy[6].toBool()
