import nimui/containers/box
import nimui/layouts/horizontal_continuous_layout
import nimui/core/component
import nimui/core/types

type
  ContinuousHBox* = ref object of Box

proc newContinuousHBox*(): ContinuousHBox =
  new result
  initComponent(result)
  result.layoutInternal = HorizontalContinuousLayout(component: result)
