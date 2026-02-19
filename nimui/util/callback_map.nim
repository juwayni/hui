import ./function_array, tables

type
  CallbackMap*[T] = ref object
    map*: Table[string, FunctionArray[proc(p: T) {.gcsafe.}]]

proc newCallbackMap*[T](): CallbackMap[T] =
  CallbackMap[T](map: initTable[string, FunctionArray[proc(p: T) {.gcsafe.}]]())

proc add*[T](self: CallbackMap[T], key: string, callback: proc(p: T) {.gcsafe.}, priority: int = 0): bool =
  if callback == nil: return false
  var res = false
  if not self.map.hasKey(key):
    self.map[key] = newFunctionArray[proc(p: T) {.gcsafe.}]()
    self.map[key].push(callback, priority)
    res = true
  elif not self.map[key].contains(callback):
    self.map[key].push(callback, priority)
  return res

proc remove*[T](self: CallbackMap[T], key: string, callback: proc(p: T) {.gcsafe.}): bool =
  var res = false
  if self.map.hasKey(key):
    discard self.map[key].remove(callback)
    if self.map[key].len == 0:
      self.map.del(key)
      res = true
  return res

proc removeAll*[T](self: CallbackMap[T], key: string) =
  if self.map.hasKey(key):
    self.map.del(key)

proc invoke*[T](self: CallbackMap[T], key: string, param: T) =
  if self.map.hasKey(key):
    let arr = self.map[key].copy()
    for i in 0 ..< arr.len:
      arr[i].callback(param)

proc count*[T](self: CallbackMap[T], key: string): int =
  if self.map.hasKey(key):
    return self.map[key].len
  return 0

proc invokeAndRemove*[T](self: CallbackMap[T], key: string, param: T) =
  if self.map.hasKey(key):
    let arr = self.map[key].copy()
    self.map.del(key)
    for i in 0 ..< arr.len:
      arr[i].callback(param)
