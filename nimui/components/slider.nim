import nimui/core/component
import nimui/core/types
import nimui/core/interactive_component
import nimui/core/composite_builder
import nimui/behaviours/behaviour
import nimui/behaviours/data_behaviour
import nimui/behaviours/default_behaviour
import nimui/events/ui_event
import nimui/events/mouse_event
import nimui/events/drag_event
import nimui/util/variant
import nimui/geom/point
import nimui/components/range
import nimui/components/button
import std/options

type
  Slider* = ref object of InteractiveComponent

proc newSlider*(): Slider =
  new result
  result.initComponent()

method posFromCoord*(self: Slider, coord: Point): float {.base.} =
  return self.behavioursInternal.call("posFromCoord", toVariant(coord)).toFloat()

# Behaviours
type
  SliderStartBehaviour* = ref object of DataBehaviour
  SliderEndBehaviour* = ref object of DataBehaviour
  SliderMinBehaviour* = ref object of DataBehaviour
  SliderMaxBehaviour* = ref object of DataBehaviour
  SliderPosBehaviour* = ref object of DataBehaviour

# Builder
type
  SliderBuilder* = ref object of CompositeBuilder

method create*(self: SliderBuilder) =
  if self.component.findComponent("range") == nil:
    # let v = self.createValueComponent()
    discard

method createBuilder*(self: Slider): CompositeBuilder =
  return SliderBuilder(component: self)
