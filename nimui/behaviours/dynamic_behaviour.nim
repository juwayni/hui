import nimui/core/types
import nimui/util/variant
import nimui/behaviours/behaviour

method getDynamic*(self: DynamicBehaviour): Variant =
  return self.dynamicValueInternal

method setDynamic*(self: DynamicBehaviour, value: Variant) =
  if value == self.dynamicValueInternal:
    return

  self.dynamicValueInternal = value

method set*(self: DynamicBehaviour, value: Variant) =
  self.setDynamic(value)
