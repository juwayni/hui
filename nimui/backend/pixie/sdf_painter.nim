import pixie
import vmath

type
  CornerRadius* = object
    tr*, br*, tl*, bl*: float

  SDFPainter* = ref object of RootObj
    ctx*: Context

proc newSDFPainter*(ctx: Context): SDFPainter =
  SDFPainter(ctx: ctx)

proc sdfRect*(self: SDFPainter, x, y, width, height: float,
              corner: CornerRadius, border: float, borderColor: Color, smooth: float,
              bottomleftColor: Color = Color(r:0, g:0, b:0, a:0),
              topleftColor: Color = Color(r:0, g:0, b:0, a:0),
              toprightColor: Color = Color(r:0, g:0, b:0, a:0),
              bottomrightColor: Color = Color(r:0, g:0, b:0, a:0)) =
  # Simplification using Pixie native rounded rect
  # Pixie doesn't easily support different radius per corner in one call but we can approximate or use a path

  self.ctx.save()
  # For now, use the max corner radius or implement a path
  let r = corner.tr # Simplified
  if border > 0:
    self.ctx.strokeStyle = borderColor
    self.ctx.lineWidth = border
    self.ctx.strokeRoundedRect(rect(x, y, width, height), r)

  # Fill with one color for now (Pixie supports paint for gradients)
  self.ctx.fillStyle = topleftColor
  self.ctx.fillRoundedRect(rect(x, y, width, height), r)
  self.ctx.restore()

proc sdfCircle*(self: SDFPainter, x, y, r, border: float, borderColor: Color, smooth: float) =
  self.ctx.save()
  if border > 0:
    self.ctx.strokeStyle = borderColor
    self.ctx.lineWidth = border
    self.ctx.strokeCircle(circle(vec2(x, y), r))

  self.ctx.fillCircle(circle(vec2(x, y), r))
  self.ctx.restore()

proc sdfLine*(self: SDFPainter, x1, y1, x2, y2, strength, smooth: float) =
  self.ctx.save()
  self.ctx.lineWidth = strength
  self.ctx.strokeSegment(segment(vec2(x1, y1), vec2(x2, y2)))
  self.ctx.restore()
