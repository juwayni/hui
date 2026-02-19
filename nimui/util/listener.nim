type
  Listener*[T] = ref object
    callback*: T
    priority*: int

proc newListener*[T](callback: T, priority: int): Listener[T] =
  Listener[T](callback: callback, priority: priority)
