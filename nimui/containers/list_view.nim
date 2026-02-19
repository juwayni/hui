import nimui/core/component
import nimui/core/types
import nimui/containers/scroll_view
import nimui/containers/ivirtual_container
import nimui/core/item_renderer
import nimui/data/data_source
import nimui/behaviours/behaviour
import nimui/behaviours/data_behaviour
import nimui/behaviours/layout_behaviour
import nimui/behaviours/default_behaviour
import nimui/core/composite_builder
import nimui/events/ui_event
import nimui/events/scroll_event
import nimui/events/item_event
import nimui/util/variant
import std/options

type
  ListView* = ref object of ScrollView

proc newListView*(): ListView =
  new result
  initComponent(result)

# Behaviours
type
  ListViewDataSourceBehaviour* = ref object of DataBehaviour
  ListViewSelectedIndexBehaviour* = ref object of Behaviour
  ListViewSelectedItemBehaviour* = ref object of Behaviour
  ListViewSelectedIndicesBehaviour* = ref object of DataBehaviour
  ListViewSelectedItemsBehaviour* = ref object of Behaviour
  ListViewSelectionModeBehaviour* = ref object of DataBehaviour

# Builder
type
  ListViewBuilder* = ref object of ScrollViewBuilder

method create*(self: ListViewBuilder) =
  let listview = cast[ListView](self.component)
  # self.createContentContainer(if listview.virtual(): "absolute" else: "vertical")
  discard

method createBuilder*(self: ListView): CompositeBuilder =
  return ListViewBuilder(component: self)

# IVirtualContainer implementation
method itemWidth*(self: ListView): float = discard
method `itemWidth=`*(self: ListView, value: float) = discard
method itemHeight*(self: ListView): float = discard
method `itemHeight=`*(self: ListView, value: float) = discard
method itemCount*(self: ListView): int = discard
method `itemCount=`*(self: ListView, value: int) = discard
method variableItemSize*(self: ListView): bool = discard
method `variableItemSize=`*(self: ListView, value: bool) = discard
method virtual*(self: ListView): bool = discard
method `virtual=`*(self: ListView, value: bool) = discard
