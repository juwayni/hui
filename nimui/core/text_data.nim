type
  TextDisplayData* = ref object
    multiline*: bool
    wordWrap*: bool
    selectable*: bool

proc newTextDisplayData*(): TextDisplayData =
  new result
  result.multiline = false
  result.wordWrap = false
  result.selectable = false

type
  TextInputData* = ref object
    onChangedCallback*: proc() {.gcsafe.}

proc newTextInputData*(): TextInputData =
  new result
