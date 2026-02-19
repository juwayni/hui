import nimui/core/types
import nimui/util/variant
import nimui/behaviours/dynamic_behaviour
import nimui/behaviours/ivalidating_behaviour

method setDynamic*(self: DynamicDataBehaviour, value: Variant) =
  if value == self.getDynamic():
    return

  self.dynamicValueInternal = value
  self.dataInvalidInternal = true
  self.component.invalidateComponentData()

method validate*(self: DynamicDataBehaviour) =
  if self.dataInvalidInternal:
    self.dataInvalidInternal = false
    self.validateData()

method validateData*(self: DynamicDataBehaviour) =
  discard
