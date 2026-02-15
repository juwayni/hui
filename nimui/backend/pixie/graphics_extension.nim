import pixie
import vmath
import math

type
  GraphicsExtension* = object

proc drawArc*(ctx: Context, cx, cy, radius, sAngle, eAngle: float, strength: float = 1, ccw: bool = false) =
  ctx.lineWidth = strength
  ctx.beginPath()
  ctx.arc(cx, cy, radius, sAngle, eAngle, ccw)
  ctx.stroke()

proc fillArc*(ctx: Context, cx, cy, radius, sAngle, eAngle: float, ccw: bool = false) =
  ctx.beginPath()
  ctx.arc(cx, cy, radius, sAngle, eAngle, ccw)
  ctx.fill()

proc drawCircle*(ctx: Context, cx, cy, radius: float, strength: float = 1) =
  ctx.lineWidth = strength
  ctx.beginPath()
  ctx.circle(circle(vec2(cx, cy), radius))
  ctx.stroke()

proc fillCircle*(ctx: Context, cx, cy, radius: float) =
  ctx.beginPath()
  ctx.circle(circle(vec2(cx, cy), radius))
  ctx.fill()

proc drawPolygon*(ctx: Context, x, y: float, vertices: seq[Vec2], strength: float = 1) =
  if vertices.len < 2: return
  ctx.lineWidth = strength
  ctx.beginPath()
  ctx.moveTo(vertices[0].x + x, vertices[0].y + y)
  for i in 1 ..< vertices.len:
    ctx.lineTo(vertices[i].x + x, vertices[i].y + y)
  ctx.closePath()
  ctx.stroke()

proc fillPolygon*(ctx: Context, x, y: float, vertices: seq[Vec2]) =
  if vertices.len < 3: return
  ctx.beginPath()
  ctx.moveTo(vertices[0].x + x, vertices[0].y + y)
  for i in 1 ..< vertices.len:
    ctx.lineTo(vertices[i].x + x, vertices[i].y + y)
  ctx.closePath()
  ctx.fill()

proc drawCubicBezier*(ctx: Context, x, y: seq[float], segments: int = 20, strength: float = 1.0) =
  if x.len < 4 or y.len < 4: return
  ctx.lineWidth = strength
  ctx.beginPath()
  ctx.moveTo(x[0], y[0])
  ctx.bezierCurveTo(x[1], y[1], x[2], y[2], x[3], y[3])
  ctx.stroke()

proc drawQuadraticBezier*(ctx: Context, x, y: seq[float], segments: int = 20, strength: float = 1.0) =
  if x.len < 3 or y.len < 3: return
  ctx.lineWidth = strength
  ctx.beginPath()
  ctx.moveTo(x[0], y[0])
  ctx.quadraticCurveTo(x[1], y[1], x[2], y[2])
  ctx.stroke()
