import ../value, ./directive

type
  AnimationKeyFrame* = ref object
    time*: Value
    directives*: seq[Directive]

proc newAnimationKeyFrame*(): AnimationKeyFrame =
  AnimationKeyFrame(directives: @[])

proc set*(self: AnimationKeyFrame, directive: Directive) =
  var found = false
  for d in self.directives:
    if d.directive == directive.directive:
      d.value = directive.value
      found = true
      break
  if not found:
    self.directives.add(directive)

proc find*(self: AnimationKeyFrame, id: string): Directive =
  for d in self.directives:
    if d.directive == id:
      return d
  return nil

proc clear*(self: AnimationKeyFrame) =
  self.directives = @[]
