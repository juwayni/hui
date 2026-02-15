import nimui/containers/box
import nimui/layouts/horizontal_layout
import nimui/layouts/layout
import nimui/core/types
import nimui/styles/style

type
  HBox* = ref object of Box

proc newHBox*(): HBox =
  new result
  result.childComponents = @[]
  result.includeInLayout = true
  result.styleInternal = newStyle()
  let l = newHorizontalLayout()
  l.component = result
  result.layoutInternal = l
