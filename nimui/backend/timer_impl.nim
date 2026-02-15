import times, os

type
  TimerImpl* = ref object
    timerId*: int
    stopped*: bool
    callback*: proc() {.closure.}
    delay*: float
    lastTime*: float

var activeTimers*: seq[TimerImpl] = @[]

proc newTimerImpl*(delayMs: int, callback: proc() {.closure.}): TimerImpl =
  let res = TimerImpl(
    delay: delayMs.float / 1000.0,
    callback: callback,
    stopped: false,
    lastTime: epochTime()
  )
  activeTimers.add(res)
  return res

proc stop*(self: TimerImpl) =
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
