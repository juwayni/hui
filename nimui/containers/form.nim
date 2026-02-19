import nimui/core/component
import nimui/core/types
import nimui/containers/box
import nimui/layouts/vertical_grid_layout
import nimui/events/ui_event
import nimui/util/variant
import std/options

type
  Form* = ref object of Box
    columnsInternal: int

proc newForm*(): Form =
  new result
  initComponent(result)
  result.columnsInternal = 2

method columns*(self: Form): int {.base.} =
  if self.layoutInternal != nil and self.layoutInternal of VerticalGridLayout:
    return cast[VerticalGridLayout](self.layoutInternal).columns
  return self.columnsInternal

method `columns=`*(self: Form, value: int) {.base.} =
  self.columnsInternal = value
  if self.layoutInternal != nil and self.layoutInternal of VerticalGridLayout:
    cast[VerticalGridLayout](self.layoutInternal).columns = value
  else:
    self.layoutInternal = newVerticalGridLayout(value)
    self.layoutInternal.component = self

method submit*(self: Form) {.base.} =
  self.dispatch(newUIEvent("submit", true))

method createLayout*(self: Form): Layout =
  return newVerticalGridLayout(self.columnsInternal)
