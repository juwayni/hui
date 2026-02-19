import nimui/core/types
import nimui/util/variant
import std/tables

# Logic for Behaviour is mostly in types.nim for inheritance, but we can put implementation methods here.

proc initBehaviour*(self: Behaviour, component: Component) =
  self.component = component
  self.config = initTable[string, string]()

method set*(self: Behaviour, value: Variant) =
  discard

method setDynamic*(self: Behaviour, value: Variant) {.base, gcsafe.} =
  self.set(value)

method detach*(self: Behaviour) {.base, gcsafe.} =
  discard

method get*(self: Behaviour): Variant =
  return toVariant(nil)

method getDynamic*(self: Behaviour): Variant {.base, gcsafe.} =
  return self.get()

method update*(self: Behaviour) =
  discard

method call*(self: Behaviour, param: Variant = toVariant(nil)): Variant =
  return toVariant(nil)

method getConfigValue*(self: Behaviour, name: string, defaultValue: string = ""): string {.base, gcsafe.} =
  return self.config.getOrDefault(name, defaultValue)

method getConfigValueBool*(self: Behaviour, name: string, defaultValue: bool = false): bool {.base, gcsafe.} =
  let v = self.getConfigValue(name)
  if v == "": return defaultValue
  return v == "true"
