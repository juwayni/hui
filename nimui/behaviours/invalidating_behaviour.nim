import nimui/core/types
import nimui/util/variant
import nimui/behaviours/value_behaviour
import nimui/backend/component_base

method get*(self: InvalidatingBehaviour): Variant =
  return self.valueInternal

method set*(self: InvalidatingBehaviour, value: Variant) =
  if value == self.valueInternal:
    return

  # self.previousValueInternal = self.valueInternal
  # self.valueInternal = value
  procCall self.ValueBehaviour.set(value)
  self.component.invalidateComponent()
