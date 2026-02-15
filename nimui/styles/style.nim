import nimui/core/types
import std/options
import nimui/util/color

proc newStyle*(): Style =
  new result
  # All options are None by default

proc apply*(self: Style, other: Style) =
  if other == nil: return
  if other.backgroundColor.isSome: self.backgroundColor = other.backgroundColor
  if other.backgroundColorEnd.isSome: self.backgroundColorEnd = other.backgroundColorEnd
  if other.backgroundGradientStyle.isSome: self.backgroundGradientStyle = other.backgroundGradientStyle
  if other.backgroundOpacity.isSome: self.backgroundOpacity = other.backgroundOpacity
  if other.borderColor.isSome: self.borderColor = other.borderColor
  if other.borderSize.isSome: self.borderSize = other.borderSize
  if other.borderRadius.isSome: self.borderRadius = other.borderRadius
  if other.color.isSome: self.color = other.color
  if other.hidden.isSome: self.hidden = other.hidden
  if other.left.isSome: self.left = other.left
  if other.top.isSome: self.top = other.top
  if other.width.isSome: self.width = other.width
  if other.height.isSome: self.height = other.height
  if other.percentWidth.isSome: self.percentWidth = other.percentWidth
  if other.percentHeight.isSome: self.percentHeight = other.percentHeight
  if other.paddingTop.isSome: self.paddingTop = other.paddingTop
  if other.paddingLeft.isSome: self.paddingLeft = other.paddingLeft
  if other.paddingRight.isSome: self.paddingRight = other.paddingRight
  if other.paddingBottom.isSome: self.paddingBottom = other.paddingBottom
  if other.horizontalAlign.isSome: self.horizontalAlign = other.horizontalAlign
  if other.verticalAlign.isSome: self.verticalAlign = other.verticalAlign
  if other.textAlign.isSome: self.textAlign = other.textAlign
  if other.fontName.isSome: self.fontName = other.fontName
  if other.fontSize.isSome: self.fontSize = other.fontSize
