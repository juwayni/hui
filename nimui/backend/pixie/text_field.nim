import pixie
import nimui/backend/pixie/scissor_helper
import strutils
import math

type
  CharPosition* = object
    row*, column*: int

  SelectionInfo* = object
    start*, `end`*: CharPosition

  CaretInfo* = object
    row*, column*: int
    visible*, force*: bool

  TextField* = ref object
    textInternal*: string
    left*, top*, width*, height*: float
    font*: Font
    fontSize*: float
    textColor*, backgroundColor*, selectedTextColor*, selectedBackgroundColor*: ColorRGBA
    caretInfoInternal*: CaretInfo
    selectionInfoInternal*: SelectionInfo
    linesInternal*: seq[string]
    scrollLeft*, scrollTop*: float

proc newTextField*(): TextField =
  new result
  result.textInternal = ""
  result.linesInternal = @[]
  result.fontSize = 14.0
  result.textColor = rgba(0, 0, 0, 255)
  result.backgroundColor = rgba(255, 255, 255, 255)
  result.selectedTextColor = rgba(255, 255, 255, 255)
  result.selectedBackgroundColor = rgba(0, 0, 255, 255)

proc render*(self: TextField, ctx: Context) =
  if self.font == nil:
    return

  ctx.fillStyle = self.backgroundColor
  ctx.fillRect(rect(self.left, self.top, self.width, self.height))

  pushScissor(ctx, self.left, self.top, self.width, self.height)

  var ypos = self.top
  for i, line in self.linesInternal:
    var xpos = self.left - self.scrollLeft
    ctx.fillStyle = self.textColor
    ctx.image.fillText(self.font, line, translate(vec2(xpos, ypos)))
    ypos += self.font.size

  if self.caretInfoInternal.visible:
    ctx.fillStyle = self.textColor
    ctx.fillRect(rect(self.left, self.top, 1, self.font.size))

  popScissor(ctx)
