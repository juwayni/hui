import pixie
import std/math

type
  CornerRadius* = object
    tr*, br*, tl*, bl*: float

proc sdfRect*(ctx: Context, x, y, width, height: float, corner: CornerRadius, border: float, borderColor: Color, smooth: float) =
  # Pixie has rounded rect support
  ctx.fillStyle = rgba(borderColor.r.uint8, borderColor.g.uint8, borderColor.b.uint8, borderColor.a.uint8)
  # Simplified - Pixie doesn't have per-corner radius in a single call easily without path
  ctx.fillRoundedRect(rect(x, y, width, height), corner.tr)

proc sdfCircle*(ctx: Context, x, y, r: float, border: float, borderColor: Color, smooth: float) =
  ctx.fillStyle = rgba(borderColor.r.uint8, borderColor.g.uint8, borderColor.b.uint8, borderColor.a.uint8)
  ctx.fillCircle(circle(vec2(x, y), r))

proc sdfLine*(ctx: Context, x1, y1, x2, y2, strength, smooth: float) =
  ctx.strokeStyle = ctx.fillStyle
  ctx.lineWidth = strength
  ctx.strokeSegment(segment(vec2(x1, y1), vec2(x2, y2)))
