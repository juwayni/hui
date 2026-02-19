import nimui/core/types
import nimui/styles/value
import nimui/styles/value_tools
import nimui/styles/directive_handler
import nimui/util/color
import nimui/util/variant
import std/tables
import std/options
import std/strutils

# Implementation of Style logic
method mergeDirectives*(self: Style, map: Table[string, Directive]) {.base.} =
  for key, v in map:
    case key:
    of "left": self.left = some(calcDimension(v.value))
    of "top": self.top = some(calcDimension(v.value))
    of "width":
      # self.autoWidth = some(constant(v.value, "auto"))
      self.width = some(calcDimension(v.value))
      self.percentWidth = some(percent(v.value))
    of "height":
      self.height = some(calcDimension(v.value))
      self.percentHeight = some(percent(v.value))
    of "color": self.color = some(color.fromInt(int(v.value)))
    of "background-color": self.backgroundColor = some(color.fromInt(int(v.value)))
    # ... (more cases)
    else: discard

method apply*(self: Style, s: Style) {.base.} =
  if s == nil: return
  if s.left.isSome: self.left = s.left
  if s.top.isSome: self.top = s.top
  if s.width.isSome: self.width = s.width
  if s.height.isSome: self.height = s.height
  if s.percentWidth.isSome: self.percentWidth = s.percentWidth
  if s.percentHeight.isSome: self.percentHeight = s.percentHeight
  if s.color.isSome: self.color = s.color
  if s.backgroundColor.isSome: self.backgroundColor = s.backgroundColor
  # ... (more fields)

method equalTo*(self: Style, s: Style): bool {.base.} =
  if s == nil: return false
  if self.left != s.left: return false
  if self.top != s.top: return false
  if self.width != s.width: return false
  if self.height != s.height: return false
  # ... (more fields)
  return true

proc newStyle*(): Style =
  new result
