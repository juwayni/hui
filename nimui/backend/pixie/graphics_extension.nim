import pixie
import std/math

proc drawArc*(ctx: Context, cx, cy, radius, sAngle, eAngle: float, strength: float = 1, ccw: bool = false) =
  # Pixie has arc functionality
  discard

proc fillArc*(ctx: Context, cx, cy, radius, sAngle, eAngle: float, ccw: bool = false) =
  discard

proc drawCircle*(ctx: Context, cx, cy, radius: float, strength: float = 1) =
  ctx.strokeStyle = ctx.fillStyle # Simplified
  ctx.lineWidth = strength
  ctx.strokeCircle(circle(vec2(cx, cy), radius))

proc fillCircle*(ctx: Context, cx, cy, radius: float) =
  ctx.fillCircle(circle(vec2(cx, cy), radius))

# More pixie mappings can be added here
