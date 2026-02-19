import nimui/core/component
import nimui/core/types
import nimui/core/interactive_component
import nimui/core/composite_builder
import nimui/layouts/horizontal_layout
import nimui/behaviours/data_behaviour
import nimui/behaviours/default_behaviour
import nimui/events/ui_event
import nimui/util/variant

type
  Switch* = ref object of InteractiveComponent

proc newSwitch*(): Switch =
  new result
  result.initComponent()

# Behaviours
type
  SwitchSelectedBehaviour* = ref object of DataBehaviour
  SwitchTextBehaviour* = ref object of DataBehaviour

# Builder
type
  SwitchBuilder* = ref object of CompositeBuilder

method createBuilder*(self: Switch): CompositeBuilder =
  return SwitchBuilder(component: self)
