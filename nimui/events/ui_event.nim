import nimui/backend/event_base
import nimui/backend/event_impl
import nimui/util/variant
import nimui/core/types

proc newUIEvent*(eventType: string, bubble: bool = false, data: RootRef = nil): UIEvent =
  result = UIEvent(
    `type`: eventType,
    bubble: bubble,
    data: data,
    canceled: false
  )

method cancel*(self: UIEvent) =
  procCall self.EventBase.cancel()
  self.canceled = true

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
