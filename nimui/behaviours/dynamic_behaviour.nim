import ./behaviour
import nimui/util/variant

type
  DynamicBehaviour* = ref object of Behaviour

method getDynamic*(self: DynamicBehaviour): Variant {.base.} =
  return self.get()

method setDynamic*(self: DynamicBehaviour, value: Variant) {.base.} =
  self.set(value)
