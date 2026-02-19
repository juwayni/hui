import nimui/core/types
import nimui/styles/elements/selector
import nimui/styles/elements/selector_part
import nimui/styles/elements/directive
import nimui/styles/value
import std/tables

type
  RuleElement* = ref object
    selector*: Selector
    directives*: Table[string, Directive]

proc newRuleElement*(sel: string, dirs: seq[Directive]): RuleElement =
  new result
  result.selector = newSelector(sel)
  result.directives = initTable[string, Directive]()
  for d in dirs:
    result.directives[d.directive] = d

proc match*(self: RuleElement, c: Component): bool =
  # Logic to match component against selector
  return true
