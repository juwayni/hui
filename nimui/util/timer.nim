import ../backend/timer_impl

type
  Timer* = ref object of TimerImpl

proc newTimer*(delay: int, callback: proc() {.gcsafe.}): Timer =
  new(result)
  result.init(delay, callback)

proc delay*(f: proc() {.gcsafe.}, timeMs: int): Timer =
  var t: Timer
  t = newTimer(timeMs, proc() {.gcsafe.} =
    if t != nil:
      t.stop()
    f()
  )
  return t

method stop*(self: Timer) {.gcsafe.} =
  procCall stop(TimerImpl(self))
