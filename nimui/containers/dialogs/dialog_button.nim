import nimui/core/component
import nimui/core/types
import nimui/components/button

type
  DialogButton* = ref object of Button

proc newDialogButton*(): DialogButton =
  new result
  initComponent(result)
