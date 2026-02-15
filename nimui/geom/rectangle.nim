type
  Rectangle* = ref object
    left*: float
    top*: float
    width*: float
    height*: float

proc newRectangle*(left: float = 0, top: float = 0, width: float = 0, height: float = 0): Rectangle =
  Rectangle(left: left, top: top, width: width, height: height)

proc set*(self: Rectangle, left: float = 0, top: float = 0, width: float = 0, height: float = 0) =
  self.left = left
  self.top = top
  self.width = width
  self.height = height

proc right*(self: Rectangle): float = self.left + self.width
proc `right=`*(self: Rectangle, value: float) = self.width = value - self.left

proc bottom*(self: Rectangle): float = self.top + self.height
proc `bottom=`*(self: Rectangle, value: float) = self.height = value - self.top

proc intersects*(self, rect: Rectangle): bool =
  let x0 = if self.left < rect.left: rect.left else: self.left
  let x1 = if self.right() > rect.right(): rect.right() else: self.right()
  if x1 <= x0: return false
  let y0 = if self.top < rect.top: rect.top else: self.top
  let y1 = if self.bottom() > rect.bottom(): rect.bottom() else: self.bottom()
  return y1 > y0

proc intersection*(self, rect: Rectangle): Rectangle =
  let x0 = if self.left < rect.left: rect.left else: self.left
  let x1 = if self.right() > rect.right(): rect.right() else: self.right()
  if x1 <= x0: return newRectangle()
  let y0 = if self.top < rect.top: rect.top else: self.top
  let y1 = if self.bottom() > rect.bottom(): rect.bottom() else: self.bottom()
  if y1 <= y0: return newRectangle()
  return newRectangle(x0, y0, x1 - x0, y1 - y0)
