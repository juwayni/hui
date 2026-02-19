import nimui/core/component
import nimui/core/types
import nimui/components/progress
import nimui/components/horizontal_range
import nimui/geom/point

type
  HorizontalProgress* = ref object of Progress

proc newHorizontalProgress*(): HorizontalProgress =
  new result
  result.initComponent()

method posFromCoord*(self: HorizontalProgress, coord: Point): float =
  # return HorizontalRange.posFromCoord(self, coord)
  return 0.0

method createLayout*(self: HorizontalProgress): Layout =
  return HorizontalRangeLayout(component: self)
