import ./rectangle

type
  Slice9Rects* = object
    src*: seq[Rectangle]
    dst*: seq[Rectangle]

proc buildSrcRects*(bitmapWidth, bitmapHeight: float, slice: Rectangle): seq[Rectangle] =
  let x1 = slice.left
  let y1 = slice.top
  let x2 = slice.right()
  let y2 = slice.bottom()

  var srcRects: seq[Rectangle] = @[]
  srcRects.add(newRectangle(0, 0, x1, y1)) # top left
  srcRects.add(newRectangle(x1, 0, x2 - x1, y1)) # top middle
  srcRects.add(newRectangle(x2, 0, bitmapWidth - x2, y1)) # top right

  srcRects.add(newRectangle(0, y1, x1, y2 - y1)) # left middle
  srcRects.add(newRectangle(x1, y1, x2 - x1, y2 - y1)) # middle
  srcRects.add(newRectangle(x2, y1, bitmapWidth - x2, y2 - y1)) # right middle

  srcRects.add(newRectangle(0, y2, x1, bitmapHeight - y2)) # bottom left
  srcRects.add(newRectangle(x1, y2, x2 - x1, bitmapHeight - y2)) # bottom middle
  srcRects.add(newRectangle(x2, y2, bitmapWidth - x2, bitmapHeight - y2)) # bottom right

  return srcRects

proc buildDstRects*(w, h: float, srcRects: seq[Rectangle]): seq[Rectangle] =
  var dstRects: seq[Rectangle] = @[]

  dstRects.add(newRectangle(0, 0, srcRects[0].width, srcRects[0].height))
  dstRects.add(newRectangle(srcRects[0].width, 0, w - srcRects[0].width - srcRects[2].width, srcRects[1].height))
  dstRects.add(newRectangle(w - srcRects[2].width, 0, srcRects[2].width, srcRects[2].height))

  dstRects.add(newRectangle(0, srcRects[0].height, srcRects[3].width, h - srcRects[0].height - srcRects[6].height))
  dstRects.add(newRectangle(srcRects[3].width, srcRects[0].height, w - srcRects[3].width - srcRects[5].width, h - srcRects[1].height - srcRects[7].height))
  dstRects.add(newRectangle(w - srcRects[5].width, srcRects[2].height, srcRects[5].width, h - srcRects[2].height - srcRects[8].height))

  dstRects.add(newRectangle(0, h - srcRects[6].height, srcRects[6].width, srcRects[6].height))
  dstRects.add(newRectangle(srcRects[6].width, h - srcRects[7].height, w - srcRects[6].width - srcRects[8].width, srcRects[7].height))
  dstRects.add(newRectangle(w - srcRects[8].width, h - srcRects[8].height, srcRects[8].width, srcRects[8].height))

  return dstRects

proc buildRects*(w, h, bitmapWidth, bitmapHeight: float, slice: Rectangle): Slice9Rects =
  let srcRects = buildSrcRects(bitmapWidth, bitmapHeight, slice)
  let dstRects = buildDstRects(w, h, srcRects)
  return Slice9Rects(src: srcRects, dst: dstRects)
