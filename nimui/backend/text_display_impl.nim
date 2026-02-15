import nimui/backend/text_base
import nimui/backend/font_data
import nimui/styles/style
import pixie
import strutils

type
  TextDisplayImpl* = ref object of TextBase
    font: FontData
    textAlign: string
    fontSize: float
    fontName: string
    color: int
    lines: seq[string]

proc newTextDisplayImpl*(): TextDisplayImpl =
  let res = TextDisplayImpl()
  res.fontSize = 14.0
  return res

method validateStyle*(self: TextDisplayImpl): bool =
  var measureTextRequired = false
  if self.textStyle != nil:
    if self.textAlign != self.textStyle.textAlign:
      self.textAlign = self.textStyle.textAlign

    if self.textStyle.fontSize != 0 and self.fontSize != self.textStyle.fontSize:
      self.fontSize = self.textStyle.fontSize
      measureTextRequired = true

    if self.fontName != self.textStyle.fontName:
      if self.fontInfo.data != nil:
        self.font = self.fontInfo.data
        measureTextRequired = true

    if self.color != self.textStyle.color:
      self.color = self.textStyle.color

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
      self.textHeight = self.font.size # Approximate
    else:
      self.textWidth = 0
      self.textHeight = 0
    return

  if self.width <= 0:
    self.lines = @[self.text]
    let span = typeset(@[newSpan(self.text, self.font)])
    let bounds = span.computeBounds()
    self.textWidth = bounds.w
    self.textHeight = bounds.h
    return

  # Word wrapping logic using Pixie
  let span = typeset(@[newSpan(self.text, self.font)], vec2(self.width, 0))
  let bounds = span.computeBounds()
  self.textWidth = bounds.w
  self.textHeight = bounds.h

  # Extract lines from span for rendering (optional, pixie can render spans directly)
  # But the Haxe code keeps track of lines, so we might want to as well.
  # For simplicity with Pixie, we'll just use the span.

proc renderTo*(self: TextDisplayImpl, ctx: Context, x, y: float) =
  if self.font != nil and self.text != "":
    # Handle alignment
    var tx = x
    case self.textAlign:
      of "center":
        tx += (self.width - self.textWidth) / 2
      of "right":
        tx += (self.width - self.textWidth)
      else:
        discard

    ctx.image.fillText(self.font, self.text, translate(vec2(tx, y)))
