import nimui/core/component
import nimui/core/types
import nimui/components/range
import nimui/layouts/default_layout
import nimui/geom/point
import nimui/util/variant
import nimui/toolkit
import std/math
import std/options

type
  HorizontalRange* = ref object of Range

proc newHorizontalRange*(): HorizontalRange =
  new result
  result.initComponent()

# Layout
type
  HorizontalRangeLayout* = ref object of DefaultLayout

method resizeChildren*(self: HorizontalRangeLayout) =
  procCall self.DefaultLayout.resizeChildren()
  let range = cast[Range](self.component)
  let value = self.component.findComponent(range.cssName & "-value")
  if value != nil:
    let ucx = self.usableSize().width
    var start = range.behavioursInternal.get("start").toFloat()
    var endVal = range.behavioursInternal.get("end").toFloat()

    if range.virtualStart.isSome: start = range.virtualStart.get()
    if range.virtualEnd.isSome: endVal = range.virtualEnd.get()

    let min = range.behavioursInternal.get("min").toFloat()
    let max = range.behavioursInternal.get("max").toFloat()

    let m = max - min
    if m > 0:
      let d = ucx / m
      let startInPixels = (start * d) - (min * d)
      let endInPixels = (endVal * d) - (min * d)
      let cx = ceil(endInPixels - startInPixels)

      if cx <= 0:
        value.widthInternal = 0
        value.styleInternal.hidden = some(true)
      else:
        value.widthInternal = cx
        value.styleInternal.hidden = some(false)

method repositionChildren*(self: HorizontalRangeLayout) =
  procCall self.DefaultLayout.repositionChildren()
  let range = cast[Range](self.component)
  let value = self.component.findComponent(range.cssName & "-value")
  if value != nil:
    var start = range.behavioursInternal.get("start").toFloat()
    if range.virtualStart.isSome: start = range.virtualStart.get()

    let min = range.behavioursInternal.get("min").toFloat()
    let max = range.behavioursInternal.get("max").toFloat()

    let ucx = self.usableSize().width
    let m = max - min
    if m > 0:
      let d = ucx / m
      let startInPixels = (start * d) - (min * d)
      value.leftInternal = floor(self.paddingLeft + startInPixels)
      value.topInternal = self.paddingTop

method createLayout*(self: HorizontalRange): Layout =
  return HorizontalRangeLayout(component: self)

# PosFromCoord Behaviour
type
  HorizontalRangePosFromCoord* = ref object of Behaviour

method call*(self: HorizontalRangePosFromCoord, param: Variant): Variant =
  let range = cast[Range](self.component)
  let p = param.toPoint()
  # p.x -= range.getComponentOffset().x

  var xpos = p.x - range.layoutInternal.paddingLeft
  let ucx = range.layoutInternal.usableWidth() # * Toolkit.scaleX
  if xpos >= ucx: xpos = ucx
  if xpos <= 0: xpos = 0

  let min = range.behavioursInternal.get("min").toFloat()
  let max = range.behavioursInternal.get("max").toFloat()
  let m = max - min

  let v = (xpos / ucx) * m + min
  return toVariant(v)
