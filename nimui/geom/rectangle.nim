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
proc `right=`*(self: Rectangle, value: float) =
  self.width = value - self.left

proc bottom*(self: Rectangle): float = self.top + self.height
proc `bottom=`*(self: Rectangle, value: float) =
  self.height = value - self.top

proc inflate*(self: Rectangle, dx, dy: float) =
  self.left -= dx
  self.width += dx * 2
  self.top -= dy
  self.height += dy * 2

proc equals*(self: Rectangle, rc: Rectangle): bool =
  if rc == nil: return false
  return rc.left == self.left and rc.top == self.top and rc.width == self.width and rc.height == self.height

proc containsPoint*(self: Rectangle, x, y: float): bool =
  return x >= self.left and x < self.left + self.width and y >= self.top and y < self.top + self.height

proc containsRect*(self: Rectangle, rect: Rectangle): bool =
  if rect.width <= 0 or rect.height <= 0:
    return rect.left > self.left and rect.top > self.top and rect.right < self.right and rect.bottom < self.bottom
  else:
    return rect.left >= self.left and rect.top >= self.top and rect.right <= self.right and rect.bottom <= self.bottom

proc intersects*(self: Rectangle, rect: Rectangle): bool =
  let x0 = if self.left < rect.left: rect.left else: self.left
  let x1 = if self.right > rect.right: rect.right else: self.right
  if x1 <= x0: return false
  let y0 = if self.top < rect.top: rect.top else: self.top
  let y1 = if self.bottom > rect.bottom: rect.bottom else: self.bottom
  return y1 > y0

proc copy*(self: Rectangle): Rectangle =
  newRectangle(self.left, self.top, self.width, self.height)

proc toString*(self: Rectangle): string =
  "{left: " & $self.left & ", top: " & $self.top & ", width: " & $self.width & ", height: " & $self.height & "}"
