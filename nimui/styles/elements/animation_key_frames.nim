import ./animation_key_frame

type
  AnimationKeyFrames* = ref object
    id*: string
    keyFrames*: seq[AnimationKeyFrame]

proc newAnimationKeyFrames*(id: string, keyFrames: seq[AnimationKeyFrame]): AnimationKeyFrames =
  AnimationKeyFrames(id: id, keyFrames: keyFrames)
