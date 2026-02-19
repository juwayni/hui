import nimui/events/ui_event
import nimui/core/types

type
  ItemEvent* = ref object of UIEvent
    source*: Component
    sourceEvent*: UIEvent
    itemIndex*: int

proc newItemEvent*(typ: string): ItemEvent =
  new result
  result.init(typ)
  result.itemIndex = -1
