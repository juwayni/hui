import nimui/core/component
import nimui/core/types
import nimui/containers/hbox
import nimui/core/composite_builder

type
  WindowFooter* = ref object of HBox

proc newWindowFooter*(): WindowFooter =
  new result
  initComponent(result)

type
  WindowFooterBuilder* = ref object of CompositeBuilder

method createBuilder*(self: WindowFooter): CompositeBuilder =
  return WindowFooterBuilder(component: self)
