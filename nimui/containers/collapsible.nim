import nimui/core/component
import nimui/core/types
import nimui/containers/box
import nimui/containers/hbox
import nimui/containers/vbox
import nimui/components/image
import nimui/components/label
import nimui/behaviours/data_behaviour
import nimui/core/composite_builder
import nimui/layouts/vertical_layout
import nimui/util/variant
import std/options

type
  Collapsible* = ref object of Box

proc newCollapsible*(): Collapsible =
  new result
  initComponent(result)

# Behaviours
type
  CollapsibleTextBehaviour* = ref object of DataBehaviour
  CollapsibleCollapsedBehaviour* = ref object of DataBehaviour

method validateData*(self: CollapsibleTextBehaviour) =
  let label = cast[Label](self.component.findComponent("collapsible-label"))
  if label != nil:
    label.text = self.valueInternal.toString()

method validateData*(self: CollapsibleCollapsedBehaviour) =
  let component = self.component
  let header = component.findComponent("collapsible-header")
  let icon = component.findComponent("collapsible-icon")
  let label = component.findComponent("collapsible-label")

  if self.valueInternal.toBool():
    if header != nil: header.swapClass("collapsed", "expanded")
    if icon != nil: icon.swapClass("collapsed", "expanded")
    if label != nil: label.swapClass("collapsed", "expanded")
  else:
    if header != nil: header.swapClass("expanded", "collapsed")
    if icon != nil: icon.swapClass("expanded", "collapsed")
    if label != nil: label.swapClass("expanded", "collapsed")

  let content = component.findComponent("collapsible-content")
  if content != nil:
    content.styleInternal.hidden = some(self.valueInternal.toBool())

# Builder
type
  CollapsibleBuilder* = ref object of CompositeBuilder

method create*(self: CollapsibleBuilder) =
  let collapsible = cast[Collapsible](self.component)
  collapsible.animatableInternal = false # Start disabled

  let header = newHBox()
  header.percentWidthInternal = some(100.0)
  header.idInternal = "collapsible-header"
  header.addClass("collapsible-header")

  let icon = newImage()
  icon.addClass("collapsible-icon")
  icon.idInternal = "collapsible-icon"
  header.addComponent(icon)

  let label = newLabel()
  label.addClass("collapsible-label")
  label.idInternal = "collapsible-label"
  label.text = "Collapsible"
  header.addComponent(label)

  collapsible.addComponent(header)

  let content = newVBox()
  content.addClass("collapsible-content")
  content.idInternal = "collapsible-content"
  content.styleInternal.hidden = some(true)
  collapsible.addComponent(content)

method addComponent*(self: CollapsibleBuilder, child: Component): Component =
  let header = self.component.findComponent("collapsible-header")
  let content = self.component.findComponent("collapsible-content")
  if child != header and child != content:
    return content.addComponent(child)
  return nil

method createBuilder*(self: Collapsible): CompositeBuilder =
  return CollapsibleBuilder(component: self)

type
  CollapsibleLayout* = ref object of VerticalLayout

method createLayout*(self: Collapsible): Layout =
  return CollapsibleLayout(component: self)
