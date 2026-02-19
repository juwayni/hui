import nimui/tooltips/tooltip
import nimui/tooltips/tooltip_options
import nimui/core/types
import nimui/core/component
import nimui/core/screen
import nimui/events/ui_event
import nimui/events/mouse_event
import nimui/util/timer
import std/tables

type
  ToolTipManager* = ref object
    toolTipOptions: Table[Component, ToolTipOptions]
    toolTipRegions: seq[ToolTipRegionOptions]
    toolTip: ToolTip

var toolTipManagerInstance: ToolTipManager

proc instance*(): ToolTipManager =
  if toolTipManagerInstance == nil:
    new toolTipManagerInstance
    toolTipManagerInstance.toolTipOptions = initTable[Component, ToolTipOptions]()
    toolTipManagerInstance.toolTipRegions = @[]
  return toolTipManagerInstance

proc registerTooltip*(self: ToolTipManager, target: Component, options: ToolTipOptions = nil) =
  # Register tooltip and events
  discard

proc unregisterTooltip*(self: ToolTipManager, target: Component) =
  self.toolTipOptions.del(target)

proc showToolTipAt*(self: ToolTipManager, x, y: float, options: ToolTipOptions) =
  # Logic to show tooltip
  discard

proc hideCurrentToolTip*(self: ToolTipManager) =
  # Logic to hide tooltip
  discard
