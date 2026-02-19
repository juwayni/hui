import nimui/events/ui_event
import nimui/constants/sort_direction

type
  SortEvent* = ref object of UIEvent
    direction*: SortDirection

proc newSortEvent*(typ: string): SortEvent =
  new result
  result.init(typ)
