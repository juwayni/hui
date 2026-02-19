import nimui/core/types
import nimui/styles/style
import nimui/styles/elements/rule_element
import nimui/styles/elements/media_query
import nimui/styles/elements/animation_key_frames
import std/tables
import std/strutils

type
  StyleSheet* = ref object
    name*: string
    rules*: seq[RuleElement]
    mediaQueries: seq[MediaQuery]
    animations*: Table[string, AnimationKeyFrames]

proc newStyleSheet*(): StyleSheet =
  new result
  result.rules = @[]
  result.mediaQueries = @[]
  result.animations = initTable[string, AnimationKeyFrames]()

proc addRule*(self: StyleSheet, el: RuleElement) =
  self.rules.add(el)

proc addAnimation*(self: StyleSheet, el: AnimationKeyFrames) =
  self.animations[el.id] = el

proc buildStyleFor*(self: StyleSheet, c: Component, style: Style = nil): Style =
  var res = style
  if res == nil: res = newStyle()

  for r in self.rules:
    # if r.match(c):
    #   res.mergeDirectives(r.directives)
    discard
  return res

proc parse*(self: StyleSheet, css: string) =
  # Call CSS parser
  discard

proc merge*(self: StyleSheet, other: StyleSheet) =
  self.rules.add(other.rules)
  # ... (merge other lists)
  for k, v in other.animations:
    self.animations[k] = v
