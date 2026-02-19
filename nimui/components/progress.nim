import nimui/core/component
import nimui/core/types
import nimui/components/range
import nimui/behaviours/default_behaviour
import nimui/behaviours/value_behaviour
import nimui/util/variant

type
  Progress* = ref object of Range

proc newProgress*(): Progress =
  new result
  result.initComponent()

# Behaviours
type
  ProgressPosBehaviour* = ref object of DefaultBehaviour
  ProgressMinBehaviour* = ref object of DefaultBehaviour
  ProgressIndeterminateBehaviour* = ref object of ValueBehaviour

# Builder
type
  ProgressBuilder* = ref object of RangeBuilder

method createBuilder*(self: Progress): CompositeBuilder =
  return ProgressBuilder(component: self)
