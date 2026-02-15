import pixie

type
  CornerRadius* = object
    tl*, tr*, bl*, br*: float

proc sdfRect*(ctx: Context, x, y, w, h: float, corner: CornerRadius, border: float, borderColor: ColorRGBA, smooth: float) =
  ctx.fillRoundedRect(rect(x, y, w, h), corner.tl, corner.tr, corner.br, corner.bl)
  if border > 0:
    ctx.strokeStyle = borderColor
    ctx.lineWidth = border
    ctx.strokeRoundedRect(rect(x, y, w, h), corner.tl, corner.tr, corner.br, corner.bl)

proc sdfCircle*(ctx: Context, x, y, r: float, border: float, borderColor: ColorRGBA, smooth: float) =
  ctx.fillEllipse(vec2(x, y), r, r)
  if border > 0:
    ctx.strokeStyle = borderColor
    ctx.lineWidth = border
    ctx.strokeEllipse(vec2(x, y), r, r)

proc sdfLine*(ctx: Context, x1, y1, x2, y2: float, strength: float, smooth: float) =
  ctx.strokeStyle = ctx.fillStyle # Use current fill color as stroke color for line
  ctx.lineWidth = strength
  ctx.strokeSegment(segment(vec2(x1, y1), vec2(x2, y2)))
