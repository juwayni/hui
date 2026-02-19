import nimui/core/component
import nimui/core/types
import nimui/containers/dialogs/dialog

type
  MessageDialog* = ref object of Dialog

proc newMessageDialog*(): MessageDialog =
  new result
  initComponent(result)
