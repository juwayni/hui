import nimui/core/component
import nimui/util/variant
import tables

type
  Behaviour* = ref object of RootObj
    config*: TableRef[string, string]
    component*: Component
    id*: string

proc newBehaviour*(component: Component): Behaviour =
  Behaviour(component: component, config: newTable[string, string]())

method set*(self: Behaviour, value: Variant) {.base.} =
  discard

method setDynamic*(self: Behaviour, value: RootRef) {.base.} =
  # self.set(Variant.fromDynamic(value))
  discard

method detatch*(self: Behaviour) {.base.} =
  discard

method get*(self: Behaviour): Variant {.base.} =
  return VNone()

method getDynamic*(self: Behaviour): RootRef {.base.} =
  # return Variant.toDynamic(self.get())
  return nil

method update*(self: Behaviour) {.base.} =
  discard

method call*(self: Behaviour, param: RootRef = nil): Variant {.base.} =
  return VNone()

proc getConfigValue*(self: Behaviour, name: string, defaultValue: string = ""): string =
  if self.config == nil: return defaultValue
  return self.config.getOrDefault(name, defaultValue)

proc getConfigValueBool*(self: Behaviour, name: string, defaultValue: bool = false): bool =
  let v = self.getConfigValue(name)
  if v == "": return defaultValue
  return v == "true"
