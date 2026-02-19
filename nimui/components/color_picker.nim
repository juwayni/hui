import nimui/core/component
import nimui/core/types
import nimui/containers/box
import nimui/util/color
import nimui/util/color_util
import nimui/events/ui_event
import nimui/behaviours/behaviours
import std/options

type
  ColorPicker* = ref object of Box
    impl*: ColorPickerImpl

  ColorPickerImpl* = ref object of Box
    currentColorInternal*: Color

proc newColorPicker*(): ColorPicker =
  new result
  result.initComponent()

method currentColor*(self: ColorPicker): Color {.base.} =
  return self.impl.currentColorInternal

method `currentColor=`*(self: ColorPicker, value: Color) {.base.} =
  self.impl.currentColorInternal = value
  # self.impl.onCurrentColorChanged()
