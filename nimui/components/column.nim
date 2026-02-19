import nimui/core/component
import nimui/core/types
import nimui/components/button
import nimui/constants/sort_direction
import nimui/events/mouse_event
import nimui/events/ui_event
import nimui/util/variant

type
  Column* = ref object of Button
    sortField*: string
    sortDirectionInternal*: SortDirection

proc newColumn*(): Column =
  new result
  result.initComponent()

method sortable*(self: Column): bool {.base.} =
  return self.hasClass("sortable")

method `sortable=`*(self: Column, value: bool) {.base.} =
  if value:
    self.addClass("sortable")
  else:
    self.removeClass("sortable")

method sortDirection*(self: Column): SortDirection {.base.} =
  return self.sortDirectionInternal

method `sortDirection=`*(self: Column, value: SortDirection) {.base.} =
  if self.sortDirectionInternal == value:
    return

  self.sortDirectionInternal = value
  self.sortable = true
  if value == SortDirection.Ascending:
    self.swapClass("sort-asc", "sort-desc")
  elif value == SortDirection.Descending:
    self.swapClass("sort-desc", "sort-asc")
  else:
    self.removeClasses(@["sort-asc", "sort-desc"])

# Events
type
  ColumnEvents* = ref object of ButtonEvents

method onColumnClick(self: ColumnEvents, event: MouseEvent) =
  let column = cast[Column](self.button)
  if not column.sortable: return

  # Check if other interactive components are under point
  # ...

  if column.sortDirectionInternal == SortDirection.None:
    column.sortDirection = SortDirection.Ascending
  elif column.sortDirectionInternal == SortDirection.Ascending:
    column.sortDirection = SortDirection.Descending
  else:
    column.sortDirection = SortDirection.Ascending

  let sortEvent = newUIEvent("sortChanged")
  # sortEvent.direction = column.sortDirectionInternal
  column.dispatch(sortEvent)

method createBuilder*(self: Column): CompositeBuilder =
  return ButtonBuilder(component: self)
