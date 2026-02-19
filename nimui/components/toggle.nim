import nimui/core/component
import nimui/core/types
import nimui/components/button

type
  Toggle* = ref object of Button

proc newToggle*(): Toggle =
  new result
  result.initComponent()
  # result.toggle = true # Need to set this in Behaviours initialization or here
  result.set("toggle", toVariant(true))
