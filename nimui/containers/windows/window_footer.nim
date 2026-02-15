import nimui/containers/hbox
import nimui/core/types
import nimui/styles/style
import nimui/layouts/horizontal_layout
import nimui/layouts/layout

type
  WindowFooter* = ref object of HBox

proc newWindowFooter*(): WindowFooter =
  new result
  result.childComponents = @[]
  result.includeInLayout = true
  result.styleInternal = newStyle()
  let l = newHorizontalLayout()
  l.component = result
  result.layoutInternal = l
