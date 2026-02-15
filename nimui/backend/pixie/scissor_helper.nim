import nimui/geom/rectangle
import pixie

type
  ScissorEntry = object
    ctx: Context
    rect: Rectangle

var scissorStack: seq[ScissorEntry] = @[]

proc pushScissor*(ctx: Context, x, y, w, h: int) =
  let rect = newRectangle(x.float, y.float, w.float, h.float)
  scissorStack.add(ScissorEntry(ctx: ctx, rect: rect))
  ctx.save()
  # Pixie's clip is an intersection with current clip if nested
  ctx.beginPath()
  ctx.rect(rect(x.float, y.float, w.float, h.float))
  ctx.clip()

proc popScissor*(ctx: Context) =
  if scissorStack.len > 0:
    discard scissorStack.pop()
    ctx.restore()
