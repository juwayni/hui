import nimui/core/component
import nimui/core/types
import nimui/core/interactive_component
import nimui/core/composite_builder
import nimui/layouts/default_layout
import nimui/behaviours/behaviour
import nimui/behaviours/data_behaviour
import nimui/behaviours/default_behaviour
import nimui/events/ui_event
import nimui/events/mouse_event
import nimui/events/action_event
import nimui/util/variant
import nimui/util/timer
import nimui/geom/size
import std/tables
import std/options

type
  Button* = ref object of InteractiveComponent
    iconPositionInternal*: string
    fontSizeInternal*: float
    textAlignInternal*: string

proc newButton*(): Button =
  new result
  result.initComponent()

# Layout
type
  ButtonLayout* = ref object of DefaultLayout

method iconPosition*(self: ButtonLayout): string {.base.} =
  let component = cast[Button](self.component)
  if component.styleInternal.iconPosition.isSome:
    return component.styleInternal.iconPosition.get()
  return "left"

method resizeChildren*(self: ButtonLayout) =
  procCall self.DefaultLayout.resizeChildren()
  let component = cast[Button](self.component)
  if not component.autoWidth:
    let label = cast[Label](component.findComponent("button-label"))
    let ucx = self.usableSize().width
    if label != nil:
      if label.widthInternal > 0 and component.widthInternal > 0 and ucx > 0 and label.widthInternal >= ucx:
        label.widthInternal = ucx

  if not component.autoHeight:
    let icon = cast[Image](component.findComponent("button-icon"))
    let ucy = self.usableSize().height
    if icon != nil and not icon.styleInternal.hidden.get(false):
      if icon.heightInternal > 0 and ucy > 0 and icon.heightInternal > ucy:
        let ratio = icon.widthInternal / icon.heightInternal
        icon.heightInternal = ucy
        icon.widthInternal = ucy * ratio

method get_usableSize*(self: ButtonLayout): Size =
  var size = procCall self.DefaultLayout.usableSize()
  let component = cast[Button](self.component)
  let icon = cast[Image](component.findComponent("button-icon"))
  let iconPos = self.iconPosition()

  if icon != nil and not icon.styleInternal.hidden.get(false):
    if iconPos in ["far-right", "far-left", "left", "right", "center-left", "center-right"]:
      size.width -= icon.widthInternal + self.horizontalSpacing
  return size

method repositionChildren*(self: ButtonLayout) =
  procCall self.DefaultLayout.repositionChildren()
  let component = cast[Button](self.component)
  let label = cast[Label](component.findComponent("button-label"))
  let icon = cast[Image](component.findComponent("button-icon"))

  if label != nil:
    label.topInternal = (component.heightInternal / 2) - (label.heightInternal / 2)
    # Simplified positioning logic
    label.leftInternal = self.paddingLeft

  if icon != nil:
    icon.topInternal = (component.heightInternal / 2) - (icon.heightInternal / 2)
    if label != nil:
      icon.leftInternal = label.leftInternal + label.widthInternal + self.horizontalSpacing
    else:
      icon.leftInternal = (component.widthInternal / 2) - (icon.widthInternal / 2)

# Behaviours
type
  ButtonTextBehaviour* = ref object of DataBehaviour
  ButtonIconBehaviour* = ref object of DataBehaviour
  ButtonToggleBehaviour* = ref object of Behaviour
    valueInternal: Variant
  ButtonSelectedBehaviour* = ref object of DataBehaviour
  ButtonGroupBehaviour* = ref object of DataBehaviour

method validateData*(self: ButtonTextBehaviour) =
  let component = self.component
  var label = cast[Label](component.findComponent("button-label"))
  if self.valueInternal.kind == vkNull:
    if label != nil:
      component.removeClass("has-label")
      component.removeComponent(label)
  else:
    if label == nil:
      label = newLabel()
      label.idInternal = "button-label"
      component.addClass("has-label")
      component.addComponent(label)
      component.invalidateComponentStyle(true)
    label.text = self.valueInternal.toString()

method validateData*(self: ButtonIconBehaviour) =
  let component = self.component
  var icon = cast[Image](component.findComponent("button-icon"))
  if self.valueInternal.kind == vkNull or self.valueInternal.toString() == "":
    if icon != nil:
      component.removeClass("has-icon")
      component.removeComponent(icon)
  else:
    if icon == nil:
      icon = newImage()
      icon.idInternal = "button-icon"
      icon.addClass("icon")
      component.addClass("has-icon")
      component.addComponentAt(icon, 0)
      component.invalidateComponentStyle(true)
    icon.resource = self.valueInternal

method set*(self: ButtonToggleBehaviour, value: Variant) =
  self.valueInternal = value
  let button = cast[Button](self.component)
  if not value.toBool():
    button.set("selected", toVariant(false))

method validateData*(self: ButtonSelectedBehaviour) =
  let button = cast[Button](self.component)
  # ButtonGroups selection logic
  if self.valueInternal.toBool():
    button.addClass(":down")
  else:
    button.removeClass(":down")
  button.dispatch(newUIEvent(UIEvent.CHANGE))

# Events
type
  ButtonEvents* = ref object of Events
    button*: Button
    down*: bool
    repeaterInternal*: bool
    repeatIntervalInternal*: int
    recursiveStyling*: bool

method register*(self: ButtonEvents) =
  self.registerEvent(MouseEvent.MOUSE_OVER, proc(e: UIEvent) = discard) # Simplified
  self.registerEvent(MouseEvent.MOUSE_OUT, proc(e: UIEvent) = discard)
  self.registerEvent(MouseEvent.MOUSE_DOWN, proc(e: UIEvent) = discard)

# Builder
type
  ButtonBuilder* = ref object of CompositeBuilder

method applyStyle*(self: ButtonBuilder, style: Style) =
  let button = cast[Button](self.component)
  if style.backgroundImage.isSome: # Using backgroundImage as icon proxy
    button.set("icon", toVariant(style.backgroundImage.get()))

# ButtonGroups Singleton
type
  ButtonGroups* = ref object of RootObj
    groups: Table[string, seq[Button]]

var buttonGroupsInstance: ButtonGroups = nil

proc buttonGroups*(): ButtonGroups =
  if buttonGroupsInstance == nil:
    new buttonGroupsInstance
    buttonGroupsInstance.groups = initTable[string, seq[Button]]
  return buttonGroupsInstance

# Implementation of methods ...
