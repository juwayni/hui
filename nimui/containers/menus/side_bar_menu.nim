import nimui/core/component
import nimui/core/types
import nimui/containers/menus/menu

type
  SideBarMenu* = ref object of Menu

proc newSideBarMenu*(): SideBarMenu =
  new result
  initComponent(result)
