import nimui/core/component
import nimui/core/types
import nimui/containers/hbox
import nimui/core/composite_builder

type
  PropertyItem* = ref object of HBox

proc newPropertyItem*(): PropertyItem =
  new result
  initComponent(result)

type
  PropertyItemBuilder* = ref object of CompositeBuilder

method createBuilder*(self: PropertyItem): CompositeBuilder =
  return PropertyItemBuilder(component: self)
