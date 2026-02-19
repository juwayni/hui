import nimui/core/component
import nimui/core/types
import nimui/core/interactive_component
import nimui/core/composite_builder
import nimui/layouts/horizontal_layout
import nimui/behaviours/data_behaviour
import nimui/events/ui_event
import nimui/events/mouse_event
import nimui/events/action_event
import nimui/actions/action_type
import nimui/util/variant
import nimui/components/image
import nimui/components/label
import nimui/geom/size
import std/options
import std/math

type
  CheckBox* = ref object of InteractiveComponent

  CheckBoxValue* = ref object of InteractiveComponent
    downInternal: bool

proc newCheckBox*(): CheckBox =
  new result
  result.initComponent()

# Custom Children
proc newCheckBoxValue*(): CheckBoxValue =
  new result
  result.initComponent()

method onReady*(self: CheckBoxValue) =
  procCall self.InteractiveComponent.onReady()
  # self.createIcon()
  self.registerEvent("actionStart", proc(e: UIEvent) = discard) # Simplified

# Behaviours
type
  CheckBoxTextBehaviour* = ref object of DataBehaviour
  CheckBoxSelectedBehaviour* = ref object of DataBehaviour

method validateData*(self: CheckBoxTextBehaviour) =
  let component = self.component
  var label = cast[Label](component.findComponent("checkbox-label"))
  if label == nil:
    label = newLabel()
    label.idInternal = "checkbox-label"
    label.addClass("checkbox-label")
    component.addComponent(label)
    component.invalidateComponentStyle(true)

  label.text = self.valueInternal.toString()

method validateData*(self: CheckBoxSelectedBehaviour) =
  let component = self.component
  let valueComponent = component.findComponent(CheckBoxValue)
  if valueComponent == nil: return

  if self.valueInternal.toBool():
    valueComponent.addClass(":selected")
  else:
    valueComponent.removeClass(":selected")

  let event = newUIEvent(UIEvent.CHANGE)
  event.previousValue = self.previousValueInternal
  event.value = self.valueInternal
  component.dispatch(event)

# Builder
type
  CheckBoxBuilder* = ref object of CompositeBuilder

method create*(self: CheckBoxBuilder) =
  if self.component.findComponent(CheckBoxValue) == nil:
    let value = newCheckBoxValue()
    value.idInternal = "checkbox-value"
    value.addClass("checkbox-value")
    self.component.addComponent(value)

# Layout
type
  CheckBoxLayout* = ref object of HorizontalLayout

method repositionChildren*(self: CheckBoxLayout) =
  procCall self.HorizontalLayout.repositionChildren()
  let icon = self.component.findComponent(Image, true)
  if icon != nil:
    icon.leftInternal = round(icon.leftInternal)
    icon.topInternal = round(icon.topInternal)

method calcAutoSize*(self: CheckBoxLayout, exclusions: seq[Component] = @[]): Size =
  let size = procCall self.HorizontalLayout.calcAutoSize(exclusions)
  if not self.component.autoWidth:
    let label = self.component.findComponent(Label)
    if label != nil:
      label.percentWidthInternal = some(100.0)
  return size

method createLayout*(self: CheckBox): Layout =
  return CheckBoxLayout(component: self)

method createBuilder*(self: CheckBox): CompositeBuilder =
  return CheckBoxBuilder(component: self)
