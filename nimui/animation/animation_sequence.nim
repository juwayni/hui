import nimui/animation/animation_builder

type
  AnimationSequence* = ref object
    onComplete*: proc() {.closure.}
    builders*: seq[AnimationBuilder]
    activeBuilders: seq[AnimationBuilder]

proc newAnimationSequence*(): AnimationSequence =
  AnimationSequence(builders: @[])

proc add*(self: AnimationSequence, builder: AnimationBuilder) =
  if builder == nil:
    return
  self.builders.add(builder)

proc onAnimationComplete(self: AnimationSequence) =
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

  self.activeBuilders = self.builders # Copy seq
  for builder in self.builders:
    let s = self
    builder.onComplete = proc() =
      s.onAnimationComplete()

  for builder in self.builders:
    builder.play()
