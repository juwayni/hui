import nimui/events/ui_event
import nimui/actions/action_type
import nimui/util/variant

type
  ActionEvent* = ref object of UIEvent
    action*: ActionType
    repeater*: bool

proc newActionEvent*(typ: string, action: ActionType): ActionEvent =
  new result
  result.init(typ)
  result.action = action
  result.repeater = false
