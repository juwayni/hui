import nimui/core/component
import nimui/core/types
import nimui/containers/box
import nimui/containers/hbox
import nimui/components/button
import nimui/components/calendar
import nimui/components/label
import nimui/components/stepper
import nimui/behaviours/default_behaviour
import nimui/core/composite_builder
import nimui/events/ui_event
import nimui/events/mouse_event
import nimui/util/variant
import std/times
import std/options

type
  CalendarView* = ref object of Box

proc newCalendarView*(): CalendarView =
  new result
  initComponent(result)

# Behaviours
type
  CalendarViewSelectedDateBehaviour* = ref object of DefaultBehaviour

method get*(self: CalendarViewSelectedDateBehaviour): Variant =
  let calendar = self.component.findComponent(Calendar)
  if calendar != nil:
    return toVariant(calendar.getProperty("selectedDate"))
  return toVariant(now())

method set*(self: CalendarViewSelectedDateBehaviour, value: Variant) =
  let calendar = self.component.findComponent(Calendar)
  if calendar != nil:
    calendar.setProperty("selectedDate", value)

# Builder
type
  CalendarViewBuilder* = ref object of CompositeBuilder

method create*(self: CalendarViewBuilder) =
  let box = newBox()
  box.percentWidthInternal = some(100.0)

  let prevMonth = newButton()
  prevMonth.idInternal = "prev-month"
  box.addComponent(prevMonth)

  let hbox = newHBox()
  hbox.styleInternal.horizontalAlign = some("center")
  hbox.styleInternal.verticalAlign = some("center")

  let label = newLabel()
  label.idInternal = "current-month"
  label.text = "January 2023" # Simplified
  hbox.addComponent(label)

  let stepper = newStepper()
  stepper.idInternal = "current-year"
  # stepper.min = 0 ...
  hbox.addComponent(stepper)

  box.addComponent(hbox)

  let nextMonth = newButton()
  nextMonth.idInternal = "next-month"
  nextMonth.styleInternal.horizontalAlign = some("right")
  box.addComponent(nextMonth)

  self.component.addComponent(box)

  let calendar = newCalendar()
  calendar.styleInternal.horizontalAlign = some("center")
  self.component.addComponent(calendar)

method createBuilder*(self: CalendarView): CompositeBuilder =
  return CalendarViewBuilder(component: self)
