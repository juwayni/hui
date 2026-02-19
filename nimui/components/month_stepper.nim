import nimui/core/component
import nimui/core/types
import nimui/components/option_stepper
import nimui/behaviours/behaviour
import nimui/events/ui_event
import nimui/util/variant
import std/times

type
  MonthStepper* = ref object of OptionStepper
    selectedMonthInternal*: int
    selectedYearInternal*: int

proc newMonthStepper*(): MonthStepper =
  new result
  result.initComponent()
  let n = now()
  result.selectedMonthInternal = n.month.int - 1
  result.selectedYearInternal = n.year

method incrementValue*(self: MonthStepper) =
  self.selectedMonthInternal += 1
  if self.selectedMonthInternal > 11:
    self.selectedMonthInternal = 0
    self.selectedYearInternal += 1
  self.dispatch(newUIEvent(UIEvent.CHANGE))

method deincrementValue*(self: MonthStepper) =
  self.selectedMonthInternal -= 1
  if self.selectedMonthInternal < 0:
    self.selectedMonthInternal = 11
    self.selectedYearInternal -= 1
  self.dispatch(newUIEvent(UIEvent.CHANGE))
