import ./behaviour
import ./dynamic_behaviour
import ./ivalidating_behaviour
import nimui/util/variant
import nimui/core/component
import nimui/core/types

type
  DynamicDataBehaviour* = ref object of DynamicBehaviour
    dataInvalid*: bool

method validate*(self: DynamicDataBehaviour) =
  if self.dataInvalid:
    self.dataInvalid = false
    # validateData()
    discard

method invalidateData*(self: DynamicDataBehaviour) {.base.} =
  self.dataInvalid = true
  if self.component != nil:
    self.component.invalidateComponentLayout() # Placeholder for invalidateComponentData

method set*(self: DynamicDataBehaviour, value: Variant) =
  self.valueInternal = value
  self.invalidateData()
