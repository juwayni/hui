import nimui/core/types
import nimui/behaviours/behaviour
import nimui/util/variant
import tables

type
  BehaviourInfo* = ref object of RootObj
    id*: string
    cls*: proc(c: Component): Behaviour
    defaultValue*: Variant
    config*: TableRef[string, string]
    isSet*: bool

  Behaviours* = ref object of RootObj
    component: Component
    registry: TableRef[string, BehaviourInfo]
    instances: TableRef[string, Behaviour]

proc newBehaviours*(component: Component): Behaviours =
  Behaviours(
    component: component,
    registry: newTable[string, BehaviourInfo](),
    instances: newTable[string, Behaviour]()
  )

proc register*(self: Behaviours, id: string, cls: proc(c: Component): Behaviour, defaultValue: Variant = Variant(kind: vkNull)) =
  let info = BehaviourInfo(
    id: id,
    cls: cls,
    defaultValue: defaultValue,
    isSet: false,
    config: newTable[string, string]()
  )
  self.registry[id] = info

proc find*(self: Behaviours, id: string): Behaviour =
  if self.instances.hasKey(id):
    return self.instances[id]

  if self.registry.hasKey(id):
    let info = self.registry[id]
    let b = info.cls(self.component)
    b.config = info.config
    self.instances[id] = b
    return b

  return nil

proc set*(self: Behaviours, id: string, value: Variant) =
  let b = self.find(id)
  if b != nil:
    b.set(value)
    self.registry[id].isSet = true

proc get*(self: Behaviours, id: string): Variant =
  let b = self.find(id)
  if b != nil:
    return b.get()
  return Variant(kind: vkNull)

proc validateData*(self: Behaviours) =
  for b in self.instances.values:
    b.update()
