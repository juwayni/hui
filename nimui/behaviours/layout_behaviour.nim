import nimui/core/types
import nimui/util/variant
import nimui/behaviours/value_behaviour
import nimui/backend/component_base

method set*(self: LayoutBehaviour, value: Variant) =
  if value == self.get():
    return

  procCall self.ValueBehaviour.set(value)
  self.component.invalidateComponentLayout()
