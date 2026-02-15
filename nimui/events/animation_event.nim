import nimui/events/ui_event

type
  AnimationEvent* = ref object of UIEvent

const
  AnimationEventStart* = "animationstart"
  AnimationEventEnd* = "animationend"
  AnimationEventIteration* = "animationiteration"
