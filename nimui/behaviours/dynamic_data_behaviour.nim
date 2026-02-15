import nimui/behaviours/dynamic_behaviour
import nimui/behaviours/ivalidating_behaviour
import nimui/core/component

type
  DynamicDataBehaviour* = ref object of DynamicBehaviour
    dataInvalid*: bool

method validateData*(self: DynamicDataBehaviour) {.base.} =
  discard

proc invalidateData*(self: DynamicDataBehaviour) =
  self.dataInvalid = true
  self.component.invalidateComponentData()

method setDynamic*(self: DynamicDataBehaviour, value: RootRef) =
  if value == self.getDynamic():
    return

  self.value = value
  self.invalidateData()

method validate*(self: DynamicDataBehaviour) =
  if self.dataInvalid:
    self.dataInvalid = false
    self.validateData()
