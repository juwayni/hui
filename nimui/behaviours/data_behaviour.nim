import nimui/core/types
import nimui/util/variant
import nimui/behaviours/behaviour
import nimui/behaviours/value_behaviour
import nimui/behaviours/ivalidating_behaviour

method set*(self: DataBehaviour, value: Variant) =
  if value == self.get():
    return

  self.previousValueInternal = self.valueInternal
  self.valueInternal = value
  self.dataInvalidInternal = true
  self.component.invalidateComponentData()

method validate*(self: DataBehaviour) =
  if self.dataInvalidInternal:
    self.dataInvalidInternal = false
    self.validateData()

method validateData*(self: DataBehaviour) =
  discard
