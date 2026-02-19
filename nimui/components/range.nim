import nimui/core/component
import nimui/core/types
import nimui/core/interactive_component
import nimui/core/composite_builder
import nimui/behaviours/behaviour
import nimui/behaviours/data_behaviour
import nimui/behaviours/value_behaviour
import nimui/behaviours/default_behaviour
import nimui/behaviours/invalidating_behaviour
import nimui/events/ui_event
import nimui/events/mouse_event
import nimui/util/variant
import nimui/geom/point
import std/options

type
  Range* = ref object of InteractiveComponent
    virtualStart*: Option[float]
    virtualEnd*: Option[float]

proc newRange*(): Range =
  new result
  result.initComponent()

method posFromCoord*(self: Range, coord: Point): float {.base.} =
  return self.behavioursInternal.call("posFromCoord", toVariant(coord)).toFloat()

# Behaviours
type
  RangeMinBehaviour* = ref object of DataBehaviour
  RangeMaxBehaviour* = ref object of DataBehaviour
  RangeStartBehaviour* = ref object of DataBehaviour
  RangeEndBehaviour* = ref object of DataBehaviour

# Builder
type
  RangeBuilder* = ref object of CompositeBuilder

method create*(self: RangeBuilder) =
  if self.component.findComponent(self.component.cssName & "-value") == nil:
    let v = newComponent()
    v.idInternal = self.component.cssName & "-value"
    v.addClass(self.component.cssName & "-value")
    self.component.addComponent(v)

method createBuilder*(self: Range): CompositeBuilder =
  return RangeBuilder(component: self)
