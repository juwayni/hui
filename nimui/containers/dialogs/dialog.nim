import nimui/events/ui_event
import strutils

type
  DialogButton* = string

const
  DialogButtonSave*: DialogButton = "{{save}}"
  DialogButtonYes*: DialogButton = "{{yes}}"
  DialogButtonNo*: DialogButton = "{{no}}"
  DialogButtonClose*: DialogButton = "{{close}}"
  DialogButtonOk*: DialogButton = "{{ok}}"
  DialogButtonCancel*: DialogButton = "{{cancel}}"
  DialogButtonApply*: DialogButton = "{{apply}}"

proc `|`*(lhs, rhs: DialogButton): DialogButton =
  var larr = lhs.split('|')
  var rarr = rhs.split('|')
  for r in rarr:
    if r notin larr:
      larr.add(r)
  return larr.join("|")

proc `==`*(lhs: DialogButton, rhs: DialogButton): bool =
  var larr = lhs.split('|')
  return rhs in larr

proc toArray*(self: DialogButton): seq[DialogButton] =
  var a: seq[DialogButton] = @[]
  for i in self.split('|'):
    let trimmed = i.strip()
    if trimmed.len > 0 and trimmed != "null":
      a.add(trimmed)
  return a

type
  DialogEvent* = ref object of UIEvent
    button*: DialogButton

const
  DialogEventClosed* = "dialogClosed"

proc newDialogEvent*(eventType: string): DialogEvent =
  DialogEvent(type: eventType)
