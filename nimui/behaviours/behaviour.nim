import nimui/util/variant
import nimui/core/types
import tables

type
  Behaviour* = ref object of RootObj
    component*: Component
    valueInternal*: Variant
    config*: TableRef[string, string]

proc newBehaviour*(component: Component): Behaviour =
  new result
  result.component = component
  result.config = newTable[string, string]()

method get*(self: Behaviour): Variant {.base.} =
  return self.valueInternal

method set*(self: Behaviour, value: Variant) {.base.} =
  self.valueInternal = value

method update*(self: Behaviour) {.base.} =
  discard

method call*(self: Behaviour, data: RootRef = nil): Variant {.base.} =
  return Variant(kind: vkNull)
