import nimui/core/component
import nimui/core/types
import nimui/containers/vbox
import nimui/core/composite_builder

type
  Window* = ref object of VBox

proc newWindow*(): Window =
  new result
  initComponent(result)

type
  WindowBuilder* = ref object of CompositeBuilder

method createBuilder*(self: Window): CompositeBuilder =
  return WindowBuilder(component: self)
