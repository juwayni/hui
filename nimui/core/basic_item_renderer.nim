import nimui/core/types
import nimui/core/item_renderer
import nimui/components/label
import nimui/components/image
import nimui/containers/hbox
import nimui/util/variant
import nimui/util/color
import std/options

type
  BasicItemRenderer* = ref object of ItemRenderer
    icon: Image
    label: Label

proc newBasicItemRenderer*(): BasicItemRenderer =
  new result
  # initItemRenderer(result) # Should call super

  let hbox = newHBox()
  hbox.addClass("basic-renderer-container")

  result.icon = newImage()
  result.icon.idInternal = "icon"
  result.icon.addClass("basic-renderer-icon")
  result.icon.styleInternal.verticalAlign = some("center")
  result.icon.hide()
  hbox.addComponent(result.icon)

  result.label = newLabel()
  result.label.idInternal = "text"
  result.label.addClass("basic-renderer-label")
  result.label.styleInternal.verticalAlign = some("center")
  result.label.hide()
  hbox.addComponent(result.label)

  result.addComponent(hbox)

method updateValues*(self: BasicItemRenderer, value: Variant, fieldList: seq[string] = @[], currentRecursionLevel: int = 0) =
  # super updateValues
  # procCall self.ItemRenderer.updateValues(value, fieldList, currentRecursionLevel)

  if self.label.text != "":
    self.label.show()
  else:
    self.label.hide()

  # ... (parity with haxe logic)
  discard
