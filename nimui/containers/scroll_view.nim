import nimui/core/component
import nimui/core/types
import nimui/core/composite_builder
import nimui/behaviours/behaviour
import nimui/behaviours/data_behaviour
import nimui/behaviours/layout_behaviour
import nimui/layouts/layout

type
  ScrollView* = ref object of Component

proc newScrollView*(): ScrollView =
  new result
  initComponent(result)

# Behaviours
type
  ScrollViewContentWidthBehaviour* = ref object of Behaviour
  ScrollViewContentHeightBehaviour* = ref object of Behaviour
  ScrollViewPercentContentWidthBehaviour* = ref object of Behaviour
  ScrollViewPercentContentHeightBehaviour* = ref object of Behaviour
  ScrollViewHScrollPosBehaviour* = ref object of DataBehaviour
  ScrollViewHScrollMaxBehaviour* = ref object of DataBehaviour
  ScrollViewHScrollPageSizeBehaviour* = ref object of DataBehaviour
  ScrollViewVScrollPosBehaviour* = ref object of DataBehaviour
  ScrollViewVScrollMaxBehaviour* = ref object of DataBehaviour
  ScrollViewVScrollPageSizeBehaviour* = ref object of DataBehaviour
  ScrollViewScrollModeBehaviour* = ref object of DataBehaviour

# Builder
type
  ScrollViewBuilder* = ref object of CompositeBuilder

method create*(self: ScrollViewBuilder) =
  discard

method createBuilder*(self: ScrollView): CompositeBuilder =
  return ScrollViewBuilder(component: self)

# Layout
type
  ScrollViewLayout* = ref object of Layout

method createLayout*(self: ScrollView): Layout =
  return ScrollViewLayout()
