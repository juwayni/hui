import nimui/containers/box
import nimui/layouts/absolute_layout
import nimui/core/component
import nimui/core/types

type
  Absolute* = ref object of Box

proc newAbsolute*(): Absolute =
  new result
  initComponent(result)
  result.layoutInternal = newAbsoluteLayout()
  result.layoutInternal.component = result
