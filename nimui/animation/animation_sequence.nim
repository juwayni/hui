import nimui/core/types

type
  AnimationSequence* = ref object of RootObj
    onComplete*: proc() {.gcsafe.}
    builders*: seq[AnimationBuilder]
    activeBuilders: seq[AnimationBuilder]

proc newAnimationSequence*(): AnimationSequence =
  new result
  result.builders = @[]

proc add*(self: AnimationSequence, builder: AnimationBuilder) =
  if builder == nil:
    return
  self.builders.add(builder)

proc onAnimationComplete(self: AnimationSequence) {.gcsafe.} =
  if self.activeBuilders.len > 0:
    discard self.activeBuilders.pop()

  if self.activeBuilders.len == 0:
    if self.onComplete != nil:
      self.onComplete()

proc play*(self: AnimationSequence) =
  if self.builders.len == 0:
    if self.onComplete != nil:
      self.onComplete()
    return

  self.activeBuilders = self.builders

  # We need a way to call onAnimationComplete when builder completes.
  # Since AnimationBuilder in types.nim is a ref object, we can set its onComplete.

  for builder in self.builders:
    let s = self
    builder.onComplete = proc() {.gcsafe.} =
      s.onAnimationComplete()

  for builder in self.builders:
    # builder.play() -- need to add play to AnimationBuilder in types or here
    discard
