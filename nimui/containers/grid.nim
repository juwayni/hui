import nimui/core/component
import nimui/core/types
import nimui/containers/box
import nimui/layouts/vertical_grid_layout

type
  Grid* = ref object of Box
    columnsInternal: int

proc newGrid*(): Grid =
  new result
  initComponent(result)
  result.columnsInternal = 2

method columns*(self: Grid): int {.base.} =
  if self.layoutInternal != nil and self.layoutInternal of VerticalGridLayout:
    return cast[VerticalGridLayout](self.layoutInternal).columns
  return self.columnsInternal

method `columns=`*(self: Grid, value: int) {.base.} =
  self.columnsInternal = value
  if self.layoutInternal != nil and self.layoutInternal of VerticalGridLayout:
    cast[VerticalGridLayout](self.layoutInternal).columns = value
  else:
    self.layoutInternal = newVerticalGridLayout(value)
    self.layoutInternal.component = self

method createLayout*(self: Grid): Layout =
  return newVerticalGridLayout(self.columnsInternal)
