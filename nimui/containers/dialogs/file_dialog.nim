import nimui/core/component
import nimui/core/types
import nimui/containers/dialogs/dialog

type
  FileDialog* = ref object of Dialog

proc newFileDialog*(): FileDialog =
  new result
  initComponent(result)
