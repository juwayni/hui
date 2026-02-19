import nimui/core/component
import nimui/core/types
import nimui/core/interactive_component
import nimui/core/composite_builder
import nimui/behaviours/data_behaviour
import nimui/behaviours/default_behaviour
import nimui/data/data_source
import nimui/util/variant
import std/options

type
  OptionStepper* = ref object of InteractiveComponent
    selectedIndexInternal*: int
    dataSourceInternal*: DataSource[Variant]

proc newOptionStepper*(): OptionStepper =
  new result
  result.initComponent()

method incrementValue*(self: OptionStepper) {.base.} = discard
method deincrementValue*(self: OptionStepper) {.base.} = discard

# Behaviours
type
  OptionStepperSelectedIndexBehaviour* = ref object of DataBehaviour
  OptionStepperSelectedItemBehaviour* = ref object of DataBehaviour
  OptionStepperDataSourceBehaviour* = ref object of DefaultBehaviour

# Builder
type
  OptionStepperBuilder* = ref object of CompositeBuilder

method createBuilder*(self: OptionStepper): CompositeBuilder =
  return OptionStepperBuilder(component: self)
