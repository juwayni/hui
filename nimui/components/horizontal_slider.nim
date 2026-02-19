import nimui/core/component
import nimui/core/types
import nimui/components/slider
import nimui/components/range
import nimui/components/horizontal_range
import nimui/components/button
import nimui/layouts/default_layout
import nimui/util/variant
import std/math
import std/options

type
  HorizontalSlider* = ref object of Slider

proc newHorizontalSlider*(): HorizontalSlider =
  new result
  result.initComponent()

# Layout
type
  HorizontalSliderLayout* = ref object of DefaultLayout

method repositionChildren*(self: HorizontalSliderLayout) =
  procCall self.DefaultLayout.repositionChildren()
  let slider = cast[Slider](self.component)
  let range = cast[Range](self.component.findComponent(Range))
  if range == nil: return

  let rangeValue = range.findComponent(range.cssName & "-value")
  let startThumb = cast[Button](self.component.findComponent("start-thumb"))
  let endThumb = cast[Button](self.component.findComponent("end-thumb"))

  if startThumb != nil:
    startThumb.leftInternal = (range.leftInternal + rangeValue.leftInternal) - (startThumb.widthInternal / 2)
    startThumb.leftInternal = ceil(startThumb.leftInternal)

  if endThumb != nil:
    let cx = rangeValue.widthInternal
    endThumb.leftInternal = (range.leftInternal + rangeValue.leftInternal + cx) - (endThumb.widthInternal / 2)
    endThumb.leftInternal = ceil(endThumb.leftInternal)

method createLayout*(self: HorizontalSlider): Layout =
  return HorizontalSliderLayout(component: self)

# Builder
type
  HorizontalSliderBuilder* = ref object of SliderBuilder

method createValueComponent*(self: HorizontalSliderBuilder): Range =
  return newHorizontalRange()

method createBuilder*(self: HorizontalSlider): CompositeBuilder =
  return HorizontalSliderBuilder(component: self)
