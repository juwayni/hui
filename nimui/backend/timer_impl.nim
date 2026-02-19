import times, os

type
  TimerImpl* = ref object of RootObj
    timerId*: int
    stopped*: bool
    callback*: proc() {.gcsafe.}
    delay*: float
    lastTime*: float

var activeTimers*: seq[TimerImpl] = @[]

proc init*(self: TimerImpl, delayMs: int, callback: proc() {.gcsafe.}) =
  self.delay = delayMs.float / 1000.0
  self.callback = callback
  self.stopped = false
  self.lastTime = epochTime()
  activeTimers.add(self)

method stop*(self: TimerImpl) {.base, gcsafe.} =
  self.stopped = true

proc updateTimers*() =
  let now = epochTime()
  var i = 0
  while i < activeTimers.len:
    let t = activeTimers[i]
    if t.stopped:
      activeTimers.delete(i)
      continue

    if now - t.lastTime >= t.delay:
      t.callback()
      t.lastTime = now

    i += 1
