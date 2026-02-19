import nimui/backend/text_display_impl
import nimui/styles/style
import nimui/validation/ivalidating
import nimui/validation/invalidation_flags
import nimui/core/types
import nimui/core/text_data
import std/tables

type
  TextDisplay* = ref object of TextDisplayImpl
    invalidationFlags: Table[string, bool]
    isAllInvalid: bool
    isValidating: bool
    depthInternal: int

proc newTextDisplay*(): TextDisplay =
  new result
  result.initTextBase()
  result.invalidationFlags = initTable[string, bool]()

method id*(self: TextDisplay): string {.base.} =
  if self.parentComponent == nil: return ""
  return self.parentComponent.idInternal & "_textdisplay"

method textStyle*(self: TextDisplay): Style {.base.} = self.textStyle
method `textStyle=`*(self: TextDisplay, value: Style) {.base.} =
  if value == nil: return
  self.textStyle = value
  self.invalidateComponent(InvalidationFlags.STYLE)

method text*(self: TextDisplay): string {.base.} = self.text
method `text=`*(self: TextDisplay, value: string) {.base.} =
  if self.text == value: return
  self.text = value
  self.htmlText = ""
  self.invalidateComponent(InvalidationFlags.DATA)

method left*(self: TextDisplay): float {.base.} = self.left
method `left=`*(self: TextDisplay, value: float) {.base.} =
  if self.left == value: return
  self.left = value
  self.invalidateComponent(InvalidationFlags.POSITION)

method top*(self: TextDisplay): float {.base.} = self.top
method `top=`*(self: TextDisplay, value: float) {.base.} =
  if self.top == value: return
  self.top = value
  self.invalidateComponent(InvalidationFlags.POSITION)

method width*(self: TextDisplay): float {.base.} = self.width
method `width=`*(self: TextDisplay, value: float) {.base.} =
  if self.width == value: return
  self.width = value
  self.invalidateComponent(InvalidationFlags.DISPLAY)

method height*(self: TextDisplay): float {.base.} = self.height
method `height=`*(self: TextDisplay, value: float) {.base.} =
  if self.height == value: return
  self.height = value
  self.invalidateComponent(InvalidationFlags.DISPLAY)

method isComponentInvalid*(self: TextDisplay, flag: string = InvalidationFlags.ALL): bool {.base.} =
  if self.isAllInvalid: return true
  if flag == InvalidationFlags.ALL:
    return self.invalidationFlags.len > 0
  return self.invalidationFlags.hasKey(flag)

method invalidateComponent*(self: TextDisplay, flag: string = InvalidationFlags.ALL) {.base.} =
  if self.parentComponent == nil: return
  if flag == InvalidationFlags.ALL:
    self.isAllInvalid = true
    self.parentComponent.invalidateComponent(InvalidationFlags.TEXT_DISPLAY)
  elif not self.invalidationFlags.hasKey(flag):
    self.invalidationFlags[flag] = true
    self.parentComponent.invalidateComponent(InvalidationFlags.TEXT_DISPLAY)

method validateComponent*(self: TextDisplay) {.base.} =
  if self.isValidating or not self.isComponentInvalid(): return
  self.isValidating = true

  if self.isComponentInvalid(InvalidationFlags.DATA):
    self.validateData()
  if self.isComponentInvalid(InvalidationFlags.STYLE):
    discard self.validateStyle()
  if self.isComponentInvalid(InvalidationFlags.POSITION):
    self.validatePosition()
  if self.isComponentInvalid(InvalidationFlags.DISPLAY):
    self.validateDisplay()

  self.measureText()

  self.invalidationFlags.clear()
  self.isAllInvalid = false
  self.isValidating = false
