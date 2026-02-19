import nimui/containers/box
import nimui/layouts/horizontal_layout
import nimui/layouts/horizontal_continuous_layout
import nimui/core/component
import nimui/core/types

type
  HBox* = ref object of Box

proc newHBox*(): HBox =
  new result
  initComponent(result)
  result.layoutInternal = newHorizontalLayout()
  result.layoutInternal.component = result

method continuous*(self: HBox): bool {.base.} =
  return self.layoutInternal of HorizontalContinuousLayout

method `continuous=`*(self: HBox, value: bool) {.base.} =
  if value:
    self.layoutInternal = HorizontalContinuousLayout(component: self)
  else:
    self.layoutInternal = newHorizontalLayout()
    self.layoutInternal.component = self
