import nimui/events/ui_event
import nimui/util/variant

type
  ValidatorEvent* = ref object of UIEvent
    # validator*: IValidator
    valid*: bool

proc newValidatorEvent*(typ: string): ValidatorEvent =
  new result
  result.init(typ)
