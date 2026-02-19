import ./listener

type
  FunctionArray*[T] = ref object
    array: seq[Listener[T]]

proc newFunctionArray*[T](): FunctionArray[T] =
  new result
  result.array = @[]

proc push*[T](self: FunctionArray[T], x: T, priority: int = 0) =
  let listener = newListener(x, priority)
  for i in 0 ..< self.array.len:
    if self.array[i].priority < priority:
      self.array.insert(listener, i)
      return
  self.array.add(listener)

proc remove*[T](self: FunctionArray[T], x: T): bool =
  for i in 0 ..< self.array.len:
    if self.array[i].callback == x:
      self.array.delete(i)
      return true
  return false

proc contains*[T](self: FunctionArray[T], x: T): bool =
  for i in 0 ..< self.array.len:
    if self.array[i].callback == x:
      return true
  return false

proc len*[T](self: FunctionArray[T]): int =
  if self == nil: return 0
  self.array.len

proc `[]`*[T](self: FunctionArray[T], index: int): Listener[T] =
  return self.array[index]

proc removeAll*[T](self: FunctionArray[T]) =
  self.array = @[]

iterator items*[T](self: FunctionArray[T]): Listener[T] {.inline.} =
  if self != nil:
    for item in self.array:
      yield item

proc copy*[T](self: FunctionArray[T]): FunctionArray[T] =
  let fa = newFunctionArray[T]()
  fa.array = self.array
  return fa
