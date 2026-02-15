import nimui/core/types
import nimui/core/component
import nimui/layouts/default_layout
import nimui/layouts/layout
import nimui/styles/style

type
  Box* = ref object of Component

proc newBox*(): Box =
  new result
  result.childComponents = @[]
  result.includeInLayout = true
  result.styleInternal = newStyle()
  let l = newDefaultLayout()
  l.component = result
  result.layoutInternal = l
