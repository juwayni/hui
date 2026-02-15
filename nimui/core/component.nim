import nimui/events/ui_event
import nimui/styles/elements/animation_key_frames

type
  Component* = ref object of RootObj
    pauseAnimationStyleChanges*: bool

method registerEvent*(self: Component, eventType: string, listener: proc(e: UIEvent) {.closure.}) {.base.} =
  discard

method unregisterEvents*(self: Component, eventType: string) {.base.} =
  discard

method applyAnimationKeyFrame*(self: Component, frames: AnimationKeyFrames, options: pointer) {.base.} =
  discard

method invalidateComponentData*(self: Component) {.base.} =
  discard

method getProperty*(self: Component, name: string): float {.base.} =
  return 0.0
