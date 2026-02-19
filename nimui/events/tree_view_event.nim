import nimui/events/ui_event
import nimui/core/types

type
  TreeViewEvent* = ref object of UIEvent
    # node*: TreeViewNode

proc newTreeViewEvent*(typ: string): TreeViewEvent =
  new result
  result.init(typ)
