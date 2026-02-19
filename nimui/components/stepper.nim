import nimui/core/component
import nimui/core/types
import nimui/containers/vbox
import nimui/behaviours/behaviour
import nimui/behaviours/data_behaviour
import nimui/behaviours/default_behaviour
import nimui/core/composite_builder
import nimui/events/ui_event
import nimui/util/variant

type
  Stepper* = ref object of VBox

proc newStepper*(): Stepper =
  new result
  result.initComponent()

# Behaviours
type
  StepperPosBehaviour* = ref object of DataBehaviour

# Builder
type
  StepperBuilder* = ref object of CompositeBuilder

method createBuilder*(self: Stepper): CompositeBuilder =
  return StepperBuilder(component: self)
