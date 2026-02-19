import nimui/core/component
import nimui/core/types
import nimui/containers/box
import nimui/components/button
import nimui/behaviours/data_behaviour
import nimui/behaviours/default_behaviour
import nimui/core/composite_builder
import nimui/events/ui_event
import nimui/util/variant
import std/options

type
  ButtonBar* = ref object of Box

proc newButtonBar*(): ButtonBar =
  new result
  initComponent(result)

# Behaviours
type
  ButtonBarSelectedIndex* = ref object of DataBehaviour

method validateData*(self: ButtonBarSelectedIndex) =
  let builder = cast[ButtonBarBuilder](self.component.compositeBuilderInternal)
  let currentButton = builder.currentButtonInternal

  if self.valueInternal.toInt() == -1:
    if currentButton != nil:
      currentButton.set("selected", toVariant(false))
    builder.currentButtonInternal = nil
    self.component.dispatch(newUIEvent(UIEvent.CHANGE))
    return

  let buttons = self.component.findComponents(Button, 1)
  if self.valueInternal.toInt() < 0 or self.valueInternal.toInt() >= buttons.len:
    return

  let button = buttons[self.valueInternal.toInt()]
  if currentButton == button:
    return

  if currentButton != nil:
    currentButton.set("selected", toVariant(false))

  if button != nil:
    button.set("selected", toVariant(true))
    builder.currentButtonInternal = button

  self.component.dispatch(newUIEvent(UIEvent.CHANGE))

# Builder
type
  ButtonBarBuilder* = ref object of CompositeBuilder
    currentButtonInternal*: Button

method addComponent*(self: ButtonBarBuilder, child: Component): Component =
  let bar = cast[ButtonBar](self.component)
  if not child.hasClass("button-bar-divider"):
    if bar.childComponents.len > 0:
      let divider = newComponent()
      divider.addClass("button-bar-divider")
      bar.addComponent(divider)

  if child of Button:
    let button = cast[Button](child)
    button.set("toggle", bar.getProperty("toggle"))

  return procCall self.CompositeBuilder.addComponent(child)

method createBuilder*(self: ButtonBar): CompositeBuilder =
  return ButtonBarBuilder(component: self)
