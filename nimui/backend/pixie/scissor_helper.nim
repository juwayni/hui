import pixie

proc pushScissor*(ctx: Context, x, y, w, h: float) =
  ctx.save()
  let r = rect(x, y, w, h)
  ctx.beginPath()
  ctx.rect(r)
  ctx.clip()

proc popScissor*(ctx: Context) =
  ctx.restore()
