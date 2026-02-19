import nimui/core/component
import nimui/core/types
import nimui/core/composite_builder

type
  Rule* = ref object of Component

proc newRule*(): Rule =
  new result
  result.initComponent()

# Builder
type
  RuleBuilder* = ref object of CompositeBuilder

method createBuilder*(self: Rule): CompositeBuilder =
  return RuleBuilder(component: self)
