import nimui/core/types
import strutils

type
  DialogButton* = string

const
  DialogButtonOk* = "{{ok}}"
  DialogButtonCancel* = "{{cancel}}"
  DialogButtonClose* = "{{close}}"
  DialogButtonYes* = "{{yes}}"
  DialogButtonNo* = "{{no}}"
  DialogButtonSave* = "{{save}}"
  DialogButtonApply* = "{{apply}}"

proc `|`*(lhs, rhs: DialogButton): DialogButton =
  var larr = lhs.split('|')
  var rarr = rhs.split('|')
  for r in rarr:
    if r notin larr:
      larr.add(r)
  return larr.join("|")

type
  DialogEvent* = ref object of UIEvent
    button*: DialogButton

const
  DialogEventClosed* = "dialogClosed"

proc newDialogEvent*(eventType: string, bubble: bool = false, data: RootRef = nil): DialogEvent =
  result = DialogEvent(
    `type`: eventType,
    bubble: bubble,
    data: data,
    canceled: false
  )
