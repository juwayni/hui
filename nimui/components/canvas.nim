import nimui/core/component
import nimui/core/types
import nimui/graphics/component_graphics
import nimui/data/data_source
import nimui/behaviours/data_behaviour
import nimui/behaviours/behaviours
import nimui/util/variant
import nimui/util/color
import std/tables

type
  Canvas* = ref object of Component
    componentGraphicsInternal: ComponentGraphics

proc newCanvas*(): Canvas =
  new result
  result.initComponent()
  result.componentGraphicsInternal = newComponentGraphics(result)

method componentGraphics*(self: Canvas): ComponentGraphics {.base.} =
  if self.componentGraphicsInternal == nil and self.isDisposedInternal:
    # trace("WARNING: trying to access component graphics on a disposed component")
    return nil
  return self.componentGraphicsInternal

method validateComponentLayout*(self: Canvas): bool =
  let b = procCall self.Component.validateComponentLayout()
  if self.widthInternal > 0 and self.heightInternal > 0:
    self.componentGraphicsInternal.resize(self.widthInternal, self.heightInternal)
  return b

# Behaviours
type
  CanvasDataSourceBehaviour* = ref object of DataBehaviour

method validateData*(self: CanvasDataSourceBehaviour) =
  let canvas = cast[Canvas](self.component)
  if self.valueInternal.kind == vkDataSource:
    let ds = self.valueInternal.toDataSource()
    let g = canvas.componentGraphics
    for i in 0..<ds.size():
      let item = ds.get(i)
      # item is expected to be a map-like variant
      let id = item.get("id").toString()
      case id:
      of "clear": g.clear()
      of "moveTo", "move-to":
        g.moveTo(item.get("x").toFloat(), item.get("y").toFloat())
      of "lineTo", "line-to":
        g.lineTo(item.get("x").toFloat(), item.get("y").toFloat())
      of "curveTo", "curve-to":
        g.curveTo(item.get("controlX").toFloat(), item.get("controlY").toFloat(),
                  item.get("anchorX").toFloat(), item.get("anchorY").toFloat())
      of "cubicCurveTo", "cubic-curve-to":
        g.cubicCurveTo(item.get("controlX").toFloat(), item.get("controlY").toFloat(),
                       item.get("controlX2").toFloat(), item.get("controlY2").toFloat(),
                       item.get("anchorX").toFloat(), item.get("anchorY").toFloat())
      of "strokeStyle", "stroke-style":
        let colorStr = item.get("color").toString()
        let thickness = item.get("thickness", toVariant(1.0)).toFloat()
        let alpha = item.get("alpha", toVariant(1.0)).toFloat()
        g.strokeStyle(parseColor(colorStr), thickness, alpha)
      of "fillStyle", "fill-style":
        let colorStr = item.get("color").toString()
        let alpha = item.get("alpha", toVariant(1.0)).toFloat()
        g.fillStyle(parseColor(colorStr), alpha)
      of "rectangle":
        g.rectangle(item.get("x").toFloat(), item.get("y").toFloat(),
                    item.get("width").toFloat(), item.get("height").toFloat())
      of "image":
        g.image(item.get("resource"), item.get("x").toFloat(), item.get("y").toFloat(),
                item.get("width").toFloat(), item.get("height").toFloat())
      of "circle":
        g.circle(item.get("x").toFloat(), item.get("y").toFloat(), item.get("radius").toFloat())
      of "beginPath", "begin-path": g.beginPath()
      of "closePath", "close-path": g.closePath()
      else: discard
