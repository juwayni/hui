import ./filter, ../util/variant

type
  DropShadow* = ref object of Filter
    distance*: float
    angle*: float
    color*: int
    alpha*: float
    blurX*: float
    blurY*: float
    strength*: float
    quality*: int
    inner*: bool

proc newDropShadow*(): DropShadow =
  new result

method parse*(self: DropShadow, filterDetails: seq[Variant]) =
  let defaults = @[toVariant(4.0), toVariant(45.0), toVariant(0), toVariant(1.0), toVariant(4.0), toVariant(4.0), toVariant(1.0), toVariant(1), toVariant(false), toVariant(false), toVariant(false)]
  let copy = applyDefaults(filterDetails, defaults)
  self.distance = copy[0].toFloat()
  self.angle = copy[1].toFloat()
  self.color = copy[2].toInt()
  self.alpha = copy[3].toFloat()
  self.blurX = copy[4].toFloat()
  self.blurY = copy[5].toFloat()
  self.strength = copy[6].toFloat()
  self.quality = copy[7].toInt()
  self.inner = copy[8].toBool()
