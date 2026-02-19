import nimui/core/component
import nimui/core/types
import nimui/core/interactive_component
import nimui/core/composite_builder
import nimui/behaviours/behaviour
import nimui/behaviours/data_behaviour
import nimui/behaviours/default_behaviour
import nimui/behaviours/layout_behaviour
import nimui/events/ui_event
import nimui/events/mouse_event
import nimui/events/drag_event
import nimui/util/variant
import nimui/geom/point
import nimui/components/button
import std/options

type
  Scroll* = ref object of InteractiveComponent

proc newScroll*(): Scroll =
  new result
  result.initComponent()

method posFromCoord*(self: Scroll, coord: Point): float {.base.} =
  return self.behavioursInternal.call("posFromCoord", toVariant(coord)).toFloat()

method applyPageFromCoord*(self: Scroll, coord: Point): float {.base.} =
  return self.behavioursInternal.call("applyPageFromCoord", toVariant(coord)).toFloat()

# Behaviours
type
  ScrollValueBehaviour* = ref object of DataBehaviour
  ScrollMinMaxBehaviour* = ref object of DataBehaviour

# Builder
type
  ScrollBuilder* = ref object of CompositeBuilder

method create*(self: ScrollBuilder) =
  # Logic to create inc, deinc, thumb buttons
  discard

method createBuilder*(self: Scroll): CompositeBuilder =
  return ScrollBuilder(component: self)
