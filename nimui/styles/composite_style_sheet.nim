import nimui/core/types
import nimui/styles/style
import nimui/styles/style_sheet
import nimui/styles/elements/animation_key_frames
import nimui/styles/elements/rule_element
import std/tables

type
  CompositeStyleSheet* = ref object
    styleSheets: seq[StyleSheet]

var compositeStyleSheetInstance: CompositeStyleSheet

proc instance*(): CompositeStyleSheet =
  if compositeStyleSheetInstance == nil:
    new compositeStyleSheetInstance
    compositeStyleSheetInstance.styleSheets = @[]
  return compositeStyleSheetInstance

proc animations*(self: CompositeStyleSheet): Table[string, AnimationKeyFrames] =
  result = initTable[string, AnimationKeyFrames]()
  for s in self.styleSheets:
    for k, v in s.animations:
      result[k] = v

proc addStyleSheet*(self: CompositeStyleSheet, s: StyleSheet) =
  self.styleSheets.add(s)

proc parse*(self: CompositeStyleSheet, css: string, name: string = "default", invalidateAll: bool = false) =
  # Find or create style sheet and parse
  discard

proc buildStyleFor*(self: CompositeStyleSheet, c: Component): Style =
  result = newStyle()
  for s in self.styleSheets:
    result = s.buildStyleFor(c, result)
