import math

type
  Point* = ref object
    x*: float
    y*: float

proc newPoint*(x: float = 0, y: float = 0): Point =
  Point(x: x, y: y)

proc length*(self: Point): float =
  sqrt(self.x * self.x + self.y * self.y)

proc multiply*(self: Point, factor: float) =
  self.x *= factor
  self.y *= factor

proc product*(self: Point, factor: float): Point =
  newPoint(self.x * factor, self.y * factor)

proc normalize*(self: Point, targetLength: float) =
  if self.x == 0 and self.y == 0: return
  let norm = targetLength / self.length()
  self.multiply(norm)

proc normalized*(self: Point, targetLength: float): Point =
  if self.x == 0 and self.y == 0: return newPoint()
  let norm = targetLength / self.length()
  return self.product(norm)

proc orth*(self: Point): Point =
  self.normalized(1)

proc copy*(self: Point): Point =
  newPoint(self.x, self.y)
