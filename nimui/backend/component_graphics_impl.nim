import nimui/core/types
import nimui/graphics/draw_command
import nimui/util/color
import nimui/util/variant
import pixie

type
  ComponentGraphicsImpl* = ref object of RootObj
    component*: Component
    drawCommands*: seq[DrawCommand]

proc newComponentGraphicsImpl*(component: Component): ComponentGraphicsImpl =
  new result
  result.component = component
  result.drawCommands = @[]

method clear*(self: ComponentGraphicsImpl) {.base.} =
  self.drawCommands = @[DrawCommand(kind: dcClear)]

method moveTo*(self: ComponentGraphicsImpl, x, y: float) {.base.} =
  self.drawCommands.add(DrawCommand(kind: dcMoveTo, posX: x, posY: y))

method lineTo*(self: ComponentGraphicsImpl, x, y: float) {.base.} =
  self.drawCommands.add(DrawCommand(kind: dcLineTo, posX: x, posY: y))

method rectangle*(self: ComponentGraphicsImpl, x, y, width, height: float) {.base.} =
  self.drawCommands.add(DrawCommand(kind: dcRectangle, rectX: x, rectY: y, rectWidth: width, rectHeight: height))

method fillStyle*(self: ComponentGraphicsImpl, color: Color, alpha: float = 1.0) {.base.} =
  self.drawCommands.add(DrawCommand(kind: dcFillStyle, fillColor: some(color), fillAlpha: some(alpha)))

method strokeStyle*(self: ComponentGraphicsImpl, color: Color, thickness: float = 1.0, alpha: float = 1.0) {.base.} =
  self.drawCommands.add(DrawCommand(kind: dcStrokeStyle, strokeColor: some(color), thickness: some(thickness), strokeAlpha: some(alpha)))

method renderTo*(self: ComponentGraphicsImpl, ctx: Context) {.base.} =
  # Actual rendering logic using Pixie
  discard
