import nimui/core/component
import nimui/core/types
import nimui/containers/grid
import nimui/components/button
import nimui/events/ui_event
import nimui/events/mouse_event
import nimui/behaviours/behaviour
import nimui/behaviours/data_behaviour
import nimui/behaviours/default_behaviour
import nimui/core/composite_builder
import nimui/layouts/vertical_grid_layout
import nimui/util/variant
import std/times
import std/math

type
  CalendarEvent* = ref object of UIEvent

proc newCalendarEvent*(typ: string): CalendarEvent =
  new result
  result.`type` = typ

type
  Calendar* = ref object of Grid
    dateInternal*: DateTime
    selectedDateInternal*: DateTime

proc newCalendar*(): Calendar =
  new result
  result.initComponent()

# Behaviours
type
  CalendarDateBehaviour* = ref object of DataBehaviour
  CalendarSelectedDateBehaviour* = ref object of DefaultBehaviour

method validateData*(self: CalendarDateBehaviour) =
  let calendar = cast[Calendar](self.component)
  # logic to build the days grid ...
  discard

# Builder
type
  CalendarBuilder* = ref object of CompositeBuilder

method create*(self: CalendarBuilder) =
  let calendar = cast[Calendar](self.component)
  calendar.columns = 7
  for i in 0..<42:
    let item = newButton()
    calendar.addComponent(item)

  calendar.dateInternal = now()

method createBuilder*(self: Calendar): CompositeBuilder =
  return CalendarBuilder(component: self)
