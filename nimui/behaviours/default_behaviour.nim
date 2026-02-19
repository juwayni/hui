import nimui/core/types
import nimui/util/variant
import nimui/behaviours/behaviour

method get*(self: DefaultBehaviour): Variant =
  return self.valueInternal

method set*(self: DefaultBehaviour, value: Variant) =
  if value == self.valueInternal:
    return

  self.valueInternal = value
  # procCall self.Behaviour.set(value)
