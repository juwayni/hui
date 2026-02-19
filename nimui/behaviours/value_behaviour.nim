import nimui/core/types
import nimui/util/variant
import nimui/behaviours/behaviour

method get*(self: ValueBehaviour): Variant =
  return self.valueInternal

method set*(self: ValueBehaviour, value: Variant) =
  if value == self.valueInternal:
    return

  self.previousValueInternal = self.valueInternal
  self.valueInternal = value
