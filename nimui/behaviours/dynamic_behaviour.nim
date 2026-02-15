import nimui/behaviours/behaviour
import nimui/util/variant

type
  DynamicBehaviour* = ref object of Behaviour
    value*: RootRef

method getDynamic*(self: DynamicBehaviour): RootRef =
  return self.value

method setDynamic*(self: DynamicBehaviour, value: RootRef) =
  if self.value == value: return
  self.value = value

method set*(self: DynamicBehaviour, value: Variant) =
  self.setDynamic(toDynamic(value))
