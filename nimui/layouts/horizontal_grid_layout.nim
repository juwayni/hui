import nimui/layouts/layout
import nimui/core/types
import nimui/geom/size
import std/options
import std/math

type
  HorizontalGridLayout* = ref object of Layout
    rowsInternal*: int

proc newHorizontalGridLayout*(): HorizontalGridLayout =
  new result
  result.rowsInternal = 1

method rows*(self: HorizontalGridLayout): int {.base.} = self.rowsInternal
method `rows=`*(self: HorizontalGridLayout, value: int) {.base.} =
  if self.rowsInternal == value: return
  self.rowsInternal = value
  if self.component != nil:
    self.component.invalidateComponentLayout()

method resizeChildren*(self: HorizontalGridLayout) =
  # Simplified implementation
  discard

method repositionChildren*(self: HorizontalGridLayout) =
  var rowIndex = 0
  var columnIndex = 0
  var xpos = self.paddingLeft()
  var ypos = self.paddingTop()

  # For real implementation, we need columnWidths and rowHeights
  # This is a stub for the complex logic
  for child in self.component.childComponents:
    if not child.includeInLayout: continue

    child.leftInternal = xpos + self.marginLeft(child)
    child.topInternal = ypos + self.marginTop(child)

    ypos += child.heightInternal + self.verticalSpacing()
    rowIndex += 1
    if rowIndex >= self.rowsInternal:
      ypos = self.paddingTop()
      # xpos += colWidth + horizontalSpacing
      rowIndex = 0
      columnIndex += 1
