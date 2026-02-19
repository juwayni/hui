import nimui/core/types
import nimui/core/item_renderer

type
  IVirtualContainer* = ref object of RootObj

method itemWidth*(self: IVirtualContainer): float {.base.} = discard
method `itemWidth=`*(self: IVirtualContainer, value: float) {.base.} = discard

method itemHeight*(self: IVirtualContainer): float {.base.} = discard
method `itemHeight=`*(self: IVirtualContainer, value: float) {.base.} = discard

method itemCount*(self: IVirtualContainer): int {.base.} = discard
method `itemCount=`*(self: IVirtualContainer, value: int) {.base.} = discard

method variableItemSize*(self: IVirtualContainer): bool {.base.} = discard
method `variableItemSize=`*(self: IVirtualContainer, value: bool) {.base.} = discard

method virtual*(self: IVirtualContainer): bool {.base.} = discard
method `virtual=`*(self: IVirtualContainer, value: bool) {.base.} = discard

method hscrollPos*(self: IVirtualContainer): float {.base.} = discard
method `hscrollPos=`*(self: IVirtualContainer, value: float) {.base.} = discard

method hscrollMax*(self: IVirtualContainer): float {.base.} = discard
method `hscrollMax=`*(self: IVirtualContainer, value: float) {.base.} = discard

method hscrollPageSize*(self: IVirtualContainer): float {.base.} = discard
method `hscrollPageSize=`*(self: IVirtualContainer, value: float) {.base.} = discard

method vscrollPos*(self: IVirtualContainer): float {.base.} = discard
method `vscrollPos=`*(self: IVirtualContainer, value: float) {.base.} = discard

method vscrollMax*(self: IVirtualContainer): float {.base.} = discard
method `vscrollMax=`*(self: IVirtualContainer, value: float) {.base.} = discard

method vscrollPageSize*(self: IVirtualContainer): float {.base.} = discard
method `vscrollPageSize=`*(self: IVirtualContainer, value: float) {.base.} = discard

method itemRenderer*(self: IVirtualContainer): ItemRenderer {.base.} = discard
method `itemRenderer=`*(self: IVirtualContainer, value: ItemRenderer) {.base.} = discard
