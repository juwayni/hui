import nimui/core/component
import nimui/core/types
import nimui/containers/scroll_view
import nimui/core/composite_builder

type
  PropertyGrid* = ref object of ScrollView

proc newPropertyGrid*(): PropertyGrid =
  new result
  initComponent(result)

type
  PropertyGridBuilder* = ref object of ScrollViewBuilder

method createBuilder*(self: PropertyGrid): CompositeBuilder =
  return PropertyGridBuilder(component: self)
