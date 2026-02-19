import nimui/events/ui_event
import nimui/core/types
import nimui/util/variant

type
  ItemRendererEvent* = ref object of UIEvent
    itemRenderer*: ItemRenderer

proc newItemRendererEvent*(typ: string): ItemRendererEvent =
  new result
  result.init(typ)
  result.bubble = true
