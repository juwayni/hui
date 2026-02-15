import nimui/backend/text_base
import nimui/backend/font_data
import pixie
import strutils
import math
import nimui/core/types
import std/options

var toolkitScale* = 1.0

type
  TextDisplayImpl* = ref object of TextBase
    fontInternal*: FontData
    textAlignInternal*: string
    fontSizeInternal*: float
    fontNameInternal*: string
    colorInternal*: int
    linesInternal*: seq[string]

proc newTextDisplayImpl*(): TextDisplayImpl =
  new result
  result.fontSizeInternal = 14.0 * toolkitScale
  result.linesInternal = @[]

method validateStyle*(self: TextDisplayImpl): bool =
  var measureTextRequired = false
  if self.textStyle != nil:
    let style = self.textStyle
    if style.textAlign.isSome and self.textAlignInternal != style.textAlign.get:
      self.textAlignInternal = style.textAlign.get

    if style.fontSize.isSome and self.fontSizeInternal != style.fontSize.get * toolkitScale:
      self.fontSizeInternal = style.fontSize.get * toolkitScale
      measureTextRequired = true

  return measureTextRequired

method validateDisplay*(self: TextDisplayImpl) =
  if self.width == 0 and self.textWidth > 0:
    self.width = self.textWidth
  if self.height == 0 and self.textHeight > 0:
    self.height = self.textHeight

method measureText*(self: TextDisplayImpl) =
  if self.text == "" or self.fontInternal == nil:
    if self.fontInternal != nil:
      self.textWidth = 0
      self.textHeight = self.fontInternal.size
    else:
      self.textWidth = 0
      self.textHeight = 0
    return

  if self.width <= 0:
    self.linesInternal = @[self.text]
    let bounds = self.fontInternal.typeset(self.text).computeBounds()
    self.textWidth = bounds.w
    self.textHeight = bounds.h
    return

  let maxWidth = self.width * toolkitScale
  self.linesInternal = @[]
  let rawLines = self.text.split('\n')
  var biggestWidth = 0.0

  for line in rawLines:
    let tw = self.fontInternal.typeset(line).computeBounds().w
    if tw > maxWidth:
      var words = line.split(' ')
      var currentLine = ""
      for word in words:
         if currentLine == "":
           currentLine = word
         else:
           let testLine = currentLine & " " & word
           if self.fontInternal.typeset(testLine).computeBounds().w <= maxWidth:
             currentLine = testLine
           else:
             self.linesInternal.add(currentLine)
             biggestWidth = max(biggestWidth, self.fontInternal.typeset(currentLine).computeBounds().w)
             currentLine = word
      if currentLine != "":
        self.linesInternal.add(currentLine)
        biggestWidth = max(biggestWidth, self.fontInternal.typeset(currentLine).computeBounds().w)
    else:
      biggestWidth = max(biggestWidth, tw)
      self.linesInternal.add(line)

  self.textWidth = biggestWidth / toolkitScale
  self.textHeight = (self.fontInternal.size * self.linesInternal.len.float) / toolkitScale

  self.textWidth = round(self.textWidth + 1)
  self.textHeight = round(self.textHeight)

  if self.textWidth.int mod 2 != 0:
    self.textWidth += 1
  if self.textHeight.int mod 2 != 0:
    self.textHeight += 1

proc renderTo*(self: TextDisplayImpl, ctx: Context, x, y: float) =
  if self.linesInternal.len > 0 and self.fontInternal != nil:
    var ty = y + self.top
    for line in self.linesInternal:
      var tx = x
      case self.textAlignInternal:
        of "center":
          tx += ((self.width - self.textWidth) * toolkitScale) / 2
        of "right":
          tx += (self.width - self.textWidth) * toolkitScale
        else:
          tx += self.left

      ctx.image.fillText(self.fontInternal, line, translate(vec2(tx, ty)))
      ty += self.fontInternal.size
