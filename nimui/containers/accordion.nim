import nimui/core/component
import nimui/core/types
import nimui/containers/vbox
import nimui/components/button
import nimui/behaviours/default_behaviour
import nimui/events/ui_event
import nimui/events/animation_event
import nimui/core/composite_builder
import nimui/util/variant
import nimui/toolkit
import std/options

type
  Accordion* = ref object of VBox

proc newAccordion*(): Accordion =
  new result
  initComponent(result)

# Behaviours
type
  AccordionPageIndex* = ref object of DefaultBehaviour

method set*(self: AccordionPageIndex, value: Variant) =
  if value == self.valueInternal:
    return

  self.valueInternal = value

  if value.toInt() == -1:
    return

  let buttons = self.component.findComponents(Button, 1)
  let selectedIndex = value.toInt()
  if selectedIndex >= buttons.len: return

  let button = buttons[selectedIndex]
  let panel = self.component.getComponentAt(self.component.getComponentIndex(button) + 1)

  panel.swapClass(":expanded", ":collapsed")
  panel.styleInternal.hidden = some(false)

  # cast[Accordion](self.component).selectedPage = panel
  button.set("selected", toVariant(true))

  for b in buttons:
    if b != button:
      let tempIndex = self.component.getComponentIndex(b)
      let tempPanel = self.component.getComponentAt(tempIndex + 1)
      b.set("selected", toVariant(false))
      tempPanel.swapClass(":collapsed", ":expanded")

  self.component.dispatch(newUIEvent(UIEvent.CHANGE))

# Builder
type
  AccordionBuilder* = ref object of CompositeBuilder

method onReady*(self: AccordionBuilder) =
  procCall self.CompositeBuilder.onReady()
  for c in self.component.childComponents:
    c.animatableInternal = true

method addComponent*(self: AccordionBuilder, child: Component): Component =
  if not child.hasClass("accordion-button") and not child.hasClass("accordion-page"):
    let button = newButton()
    button.set("text", toVariant(child.getProperty("text")))
    button.addClass("accordion-button")
    button.set("toggle", toVariant(true))
    self.component.addComponent(button)

    child.percentWidthInternal = some(100.0)
    child.addClass("accordion-page")
    let c = self.component.addComponent(child)

    if self.component.getProperty("pageIndex").toInt() == -1:
      child.percentHeightInternal = some(100.0)
      self.component.setProperty("pageIndex", toVariant(0))
    else:
      child.styleInternal.hidden = some(true)

    return c
  return nil

method createBuilder*(self: Accordion): CompositeBuilder =
  return AccordionBuilder(component: self)
