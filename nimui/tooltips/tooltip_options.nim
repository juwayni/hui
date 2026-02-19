import nimui/core/types
import nimui/core/item_renderer
import nimui/util/variant

type
  ToolTipOptions* = ref object
    tipData*: Variant
    renderer*: ItemRenderer

  ToolTipRegionOptions* = ref object of ToolTipOptions
    left*, top*, width*, height*: float

proc newToolTipOptions*(): ToolTipOptions =
  new result

proc newToolTipRegionOptions*(): ToolTipRegionOptions =
  new result
