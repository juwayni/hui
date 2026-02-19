import nimui/core/component
import nimui/core/types
import nimui/containers/box
import nimui/components/option_box
import nimui/behaviours/behaviour
import nimui/behaviours/data_behaviour
import nimui/core/composite_builder
import nimui/layouts/horizontal_layout
import nimui/events/ui_event
import nimui/util/variant
import std/tables
import std/options

type
  Group* = ref object of Box

proc newGroup*(): Group =
  new result
  initComponent(result)

# Behaviours
type
  GroupSelectedOptionBehaviour* = ref object of DataBehaviour

method get*(self: GroupSelectedOptionBehaviour): Variant =
  let optionbox = cast[OptionBox](self.component.findComponent(OptionBox))
  if optionbox != nil:
    # Logic to get from groups singleton
    discard
  return toVariant(nil)

# Builder
type
  GroupBuilder* = ref object of CompositeBuilder

method create*(self: GroupBuilder) =
  self.component.layoutInternal = newHorizontalLayout()
  self.component.layoutInternal.component = self.component

method addComponent*(self: GroupBuilder, child: Component): Component =
  # Process group child logic
  return procCall self.CompositeBuilder.addComponent(child)

method createBuilder*(self: Group): CompositeBuilder =
  return GroupBuilder(component: self)
