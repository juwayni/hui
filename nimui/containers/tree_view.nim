import nimui/core/component
import nimui/core/types
import nimui/containers/scroll_view
import nimui/containers/ivirtual_container

type
  TreeView* = ref object of ScrollView

proc newTreeView*(): TreeView =
  new result
  initComponent(result)

# IVirtualContainer implementation
method itemWidth*(self: TreeView): float = discard
method `itemWidth=`*(self: TreeView, value: float) = discard
method itemHeight*(self: TreeView): float = discard
method `itemHeight=`*(self: TreeView, value: float) = discard
method itemCount*(self: TreeView): int = discard
method `itemCount=`*(self: TreeView, value: int) = discard
method variableItemSize*(self: TreeView): bool = discard
method `variableItemSize=`*(self: TreeView, value: bool) = discard
method virtual*(self: TreeView): bool = discard
method `virtual=`*(self: TreeView, value: bool) = discard
