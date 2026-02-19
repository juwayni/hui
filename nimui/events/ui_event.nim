import nimui/backend/event_impl
import nimui/core/types
import nimui/util/variant

const
  UIEventReady* = "ready"
  UIEventDestroy* = "destroy"
  UIEventResize* = "resize"
  UIEventChange* = "change"
  UIEventBeforeChange* = "beforechange"
  UIEventMove* = "move"
  UIEventInitialize* = "initialize"
  UIEventSubmitStart* = "submitstart"
  UIEventSubmit* = "submit"
  UIEventRendererCreated* = "renderercreated"
  UIEventRendererDestroyed* = "rendererdestroyed"
  UIEventHidden* = "hidden"
  UIEventShown* = "shown"
  UIEventEnabled* = "enabled"
  UIEventDisabled* = "disabled"
  UIEventOpen* = "open"
  UIEventBeforeClose* = "beforeclose"
  UIEventClose* = "close"
  UIEventPropertyChange* = "propertychange"
  UIEventComponentCreated* = "componentcreated"
  UIEventComponentAdded* = "componentadded"
  UIEventComponentRemoved* = "componentremoved"
  UIEventComponentAddedToParent* = "componentaddedtoparent"
  UIEventComponentRemovedFromParent* = "componentremovedfromparent"

type
  UIEvent* = ref object of EventImpl
    typ*: string
    target*: Component
    bubble*: bool
    data*: Variant
    canceled*: bool
    relatedEvent*: UIEvent
    relatedComponent*: Component
    value*: Variant
    previousValue*: Variant

proc init*(self: UIEvent, typ: string, bubble: bool = false, data: Variant = toVariant(nil)) =
  self.typ = typ
  self.bubble = bubble
  self.data = data
  self.canceled = false

proc newUIEvent*(typ: string, bubble: bool = false, data: Variant = toVariant(nil)): UIEvent =
  new result
  result.init(typ, bubble, data)

method cancel*(self: UIEvent) =
  procCall self.EventImpl.cancel()
  self.canceled = true
