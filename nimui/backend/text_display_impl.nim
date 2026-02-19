import nimui/backend/text_base
import nimui/backend/font_data
import nimui/backend/toolkit_options
import pixie
import std/strutils
import std/math

type
  TextDisplayImpl* = ref object of TextBase
    font*: FontData
    textAlign*: string
    fontSize*: float
    fontName*: string
    color*: uint32
    lines*: seq[string]

proc newTextDisplayImpl*(): TextDisplayImpl =
  new result
  result.initTextBase()
  result.fontSize = 14.0 # * Toolkit.scale

method validateStyle*(self: TextDisplayImpl): bool =
  var measureTextRequired = false

  if self.textStyle != nil:
    if self.textStyle.textAlign.isSome:
      self.textAlign = self.textStyle.textAlign.get()

    if self.textStyle.fontSize.isSome and self.fontSize != self.textStyle.fontSize.get():
      self.fontSize = self.textStyle.fontSize.get() # * Toolkit.scale
      measureTextRequired = true

    if self.fontInfo != nil and self.font != self.fontInfo.data:
      self.font = self.fontInfo.data
      measureTextRequired = true

    if self.textStyle.color.isSome:
      let c = self.textStyle.color.get()
      self.color = (uint32(c.r) shl 16) or (uint32(c.g) shl 8) or uint32(c.b) or (uint32(c.a) shl 24)

  return measureTextRequired

method validateDisplay*(self: TextDisplayImpl) =
  if self.width == 0 and self.textWidth > 0:
    self.width = self.textWidth
  if self.height == 0 and self.textHeight > 0:
    self.height = self.textHeight

method measureText*(self: TextDisplayImpl) =
  if self.text == "" or self.font == nil:
    if self.font != nil:
      self.textWidth = 0
      self.textHeight = self.font.size # Simplified
    else:
      self.textWidth = 0
      self.textHeight = 0
    return

  if self.width <= 0:
    self.lines = @[self.text]
    # In pixie, we need to measure text
    # let dims = self.font.measureText(self.text)
    self.textWidth = 100.0 # TODO: real measure
    self.textHeight = self.font.size
    return

  # Word wrapping logic
  let maxWidth = self.width # * Toolkit.scale
  self.lines = @[]
  let rawLines = self.text.split("\n")
  var biggestWidth = 0.0

  for line in rawLines:
    # Simplified wrapping
    self.lines.add(line)
    biggestWidth = max(biggestWidth, 100.0) # TODO: real measure

  self.textWidth = biggestWidth
  self.textHeight = self.font.size * self.lines.len.float

  self.textWidth = round(self.textWidth + 1)
  self.textHeight = round(self.textHeight)

method renderTo*(self: TextDisplayImpl, ctx: Context, x, y: float) {.base, gcsafe.} =
  if self.lines.len > 0 and self.font != nil:
    var ty = y + self.top
    for line in self.lines:
      var tx = x

      case self.textAlign:
      of "center":
        tx += (self.width - self.textWidth) / 2.0
      of "right":
        tx += (self.width - self.textWidth)
      else:
        tx += self.left

      # Pixie draw text
      # ctx.fillText(line, tx, ty, self.font)
      ty += self.font.size
