import nimui/core/component
import nimui/core/types
import nimui/containers/scroll_view
import nimui/containers/ivirtual_container

type
  TableView* = ref object of ScrollView

proc newTableView*(): TableView =
  new result
  initComponent(result)

# IVirtualContainer implementation
method itemWidth*(self: TableView): float = discard
method `itemWidth=`*(self: TableView, value: float) = discard
method itemHeight*(self: TableView): float = discard
method `itemHeight=`*(self: TableView, value: float) = discard
method itemCount*(self: TableView): int = discard
method `itemCount=`*(self: TableView, value: int) = discard
method variableItemSize*(self: TableView): bool = discard
method `variableItemSize=`*(self: TableView, value: bool) = discard
method virtual*(self: TableView): bool = discard
method `virtual=`*(self: TableView, value: bool) = discard
