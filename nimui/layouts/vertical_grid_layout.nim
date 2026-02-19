import nimui/layouts/layout
import nimui/core/types
import nimui/geom/size
import std/options
import std/math

type
  VerticalGridLayout* = ref object of Layout
    columnsInternal*: int

proc newVerticalGridLayout*(): VerticalGridLayout =
  new result
  result.columnsInternal = 1

method columns*(self: VerticalGridLayout): int {.base.} = self.columnsInternal
method `columns=`*(self: VerticalGridLayout, value: int) {.base.} =
  if self.columnsInternal == value: return
  self.columnsInternal = value
  if self.component != nil:
    self.component.invalidateComponentLayout()

method resizeChildren*(self: VerticalGridLayout) =
  # Simplified implementation
  discard

method repositionChildren*(self: VerticalGridLayout) =
  var rowIndex = 0
  var columnIndex = 0
  var xpos = self.paddingLeft()
  var ypos = self.paddingTop()

  for child in self.component.childComponents:
    if not child.includeInLayout: continue

    child.leftInternal = xpos + self.marginLeft(child)
    child.topInternal = ypos + self.marginTop(child)

    xpos += child.widthInternal + self.horizontalSpacing()
    columnIndex += 1
    if columnIndex >= self.columnsInternal:
      xpos = self.paddingLeft()
      # ypos += rowHeight + verticalSpacing
      columnIndex = 0
      rowIndex += 1
