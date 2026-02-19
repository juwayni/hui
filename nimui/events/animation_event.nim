import nimui/events/ui_event

type
  AnimationEvent* = ref object of UIEvent
    currentTime*: float
    delta*: float
    position*: float

proc newAnimationEvent*(typ: string): AnimationEvent =
  new result
  result.init(typ)
