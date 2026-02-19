import nimui/core/types
import nimui/core/component
import nimui/behaviours/default_behaviour
import nimui/events/ui_event
import nimui/events/focus_event
import nimui/focus/focus_manager
import nimui/validators/validators
import std/options

type
  InteractiveComponent* = ref object of Component
    actionRepeatInterval*: int
    # focusInternal, allowFocusInternal, autoFocusInternal are in Component in my types.nim for now
    # to avoid complex hierarchy issues, but I should probably move them if possible.

proc initInteractiveComponent*(self: InteractiveComponent) =
  initComponent(self)
  self.actionRepeatInterval = 100
  self.allowFocusInternal = true
  self.autoFocusInternal = true

method focus*(self: InteractiveComponent): bool {.base.} = self.focusInternal
method `focus=`*(self: InteractiveComponent, value: bool) {.base.} =
  if self.focusInternal == value or not self.allowFocusInternal:
    return

  self.focusInternal = value
  var eventType = ""
  if self.focusInternal:
    eventType = "focusin"
    # FocusManager.instance().focus = self
    # Scroll into view logic...
  else:
    eventType = "focusout"
    # FocusManager.instance().focus = nil

  self.invalidateComponentData()
  self.dispatch(newFocusEvent(eventType))

method allowFocus*(self: InteractiveComponent): bool {.base.} = self.allowFocusInternal
method `allowFocus=`*(self: InteractiveComponent, value: bool) {.base.} =
  if self.allowFocusInternal == value: return
  self.allowFocusInternal = value
  for child in self.childComponents:
    if child of InteractiveComponent:
      cast[InteractiveComponent](child).allowFocus = value

method autoFocus*(self: InteractiveComponent): bool {.base.} = self.autoFocusInternal
method `autoFocus=`*(self: InteractiveComponent, value: bool) {.base.} =
  if self.autoFocusInternal == value: return
  self.autoFocusInternal = value
  for child in self.childComponents:
    if child of InteractiveComponent:
      cast[InteractiveComponent](child).autoFocus = value

method validators*(self: InteractiveComponent): Validators {.base.} =
  return cast[Validators](self.validatorsInternal)

method `validators=`*(self: InteractiveComponent, value: Validators) {.base.} =
  if value == nil:
    self.unregisterEvent("change", nil) # Should find the specific listener
  self.validatorsInternal = cast[RootRef](value)
  if value != nil:
    # value.component = self
    # self.registerEvent("change", ...)
    # value.setup()
    # value.validate()
    discard

method onInteractiveChange(self: InteractiveComponent, event: UIEvent) {.base.} =
  if self.validatorsInternal != nil:
    # cast[Validators](self.validatorsInternal).validate()
    discard

method onDestroy*(self: InteractiveComponent) =
  if self.validatorsInternal != nil:
    # cast[Validators](self.validatorsInternal).component = nil
    self.validatorsInternal = nil
  # procCall self.Component.onDestroy()
