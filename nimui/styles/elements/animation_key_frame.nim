import nimui/styles/value
import nimui/styles/elements/directive

type
  AnimationKeyFrame* = ref object
    time*: Value
    directives*: seq[Directive]

proc newAnimationKeyFrame*(): AnimationKeyFrame =
  AnimationKeyFrame(directives: @[])
