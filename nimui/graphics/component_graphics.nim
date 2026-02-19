import nimui/backend/component_graphics_impl
import nimui/core/types

type
  ComponentGraphics* = ref object of ComponentGraphicsImpl

proc newComponentGraphics*(component: Component): ComponentGraphics =
  new result
  result.component = component
  result.drawCommands = @[]
