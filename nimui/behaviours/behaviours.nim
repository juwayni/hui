import nimui/core/types
import nimui/util/variant
import nimui/behaviours/behaviour
import nimui/behaviours/ivalidating_behaviour
import std/tables
import std/sequtils
import std/strutils

type
  BehaviourCreator* = proc(component: Component): Behaviour {.gcsafe.}

  BehaviourInfo* = ref object
    id*: string
    creator*: BehaviourCreator
    defaultValue*: Variant
    config*: Table[string, string]
    isSet*: bool

  Behaviours* = ref object of RootObj
    component: Component
    registry: Table[string, BehaviourInfo]
    instances: Table[string, Behaviour]
    cacheInternal: Table[string, Variant]
    updateOrderInternal: seq[string]
    actualUpdateOrderInternal: seq[string]
    autoDispatch: Table[Behaviour, bool]

proc newBehaviours*(component: Component): Behaviours =
  new result
  result.component = component
  result.registry = initTable[string, BehaviourInfo]()
  result.instances = initTable[string, Behaviour]()
  result.updateOrderInternal = @[]
  result.autoDispatch = initTable[Behaviour, bool]()

proc register*(self: Behaviours, id: string, creator: BehaviourCreator, defaultValue: Variant = toVariant(nil)) =
  let info = BehaviourInfo(
    id: id,
    creator: creator,
    defaultValue: defaultValue,
    isSet: false,
    config: initTable[string, string]()
  )
  self.registry[id] = info
  self.updateOrderInternal.keepIf(proc(x: string): bool = x != id)
  self.updateOrderInternal.add(id)
  self.actualUpdateOrderInternal = @[]

proc isRegistered*(self: Behaviours, id: string): bool =
  return self.registry.hasKey(id)

proc actualUpdateOrder(self: Behaviours): seq[string] =
  if self.actualUpdateOrderInternal.len == 0:
    self.actualUpdateOrderInternal = self.updateOrderInternal
    for key in self.instances.keys:
      if not self.actualUpdateOrderInternal.contains(key):
        self.actualUpdateOrderInternal.add(key)
  return self.actualUpdateOrderInternal

proc validateData*(self: Behaviours) =
  let order = self.actualUpdateOrder()
  for key in order:
    if self.instances.hasKey(key):
      let b = self.instances[key]
      # Check if it implements IValidatingBehaviour
      # In Nim we'll use a method check or cast if we use a specific base
      if b of IValidatingBehaviour:
        cast[IValidatingBehaviour](b).validate()

proc update*(self: Behaviours) =
  let order = self.actualUpdateOrder()
  for key in order:
    if self.instances.hasKey(key):
      self.instances[key].update()

proc find*(self: Behaviours, id: string, create: bool = true): Behaviour =
  if self.instances.hasKey(id):
    return self.instances[id]

  if create and self.registry.hasKey(id):
    let info = self.registry[id]
    let b = info.creator(self.component)
    if b != nil:
      b.config = info.config
      b.id = id
      self.instances[id] = b
      self.actualUpdateOrderInternal = @[]
      return b

  return nil

proc cache*(self: Behaviours) =
  self.cacheInternal = initTable[string, Variant]()
  for id, info in self.registry:
    var v = info.defaultValue
    if self.instances.hasKey(id):
      v = self.instances[id].get()
    if v.kind != vkNull:
      self.cacheInternal[id] = v

proc dispose*(self: Behaviours) =
  self.component = nil
  # Registry and instances will be GCed
  self.registry.clear()
  for b in self.instances.values:
    # b.component = nil -- need access
    discard
  self.instances.clear()

proc detach*(self: Behaviours) =
  for b in self.instances.values:
    b.detach()
  self.instances.clear()

proc restore*(self: Behaviours) =
  if self.cacheInternal.len == 0:
    return

  let order = self.actualUpdateOrder()
  for key in order:
    if self.cacheInternal.hasKey(key):
      # self.set(key, self.cacheInternal[key]) -- need to define set below
      discard

  self.cacheInternal.clear()

# Forward declaration or defined after set
proc performAutoDispatch(self: Behaviours, b: Behaviour, changed: bool)

proc set*(self: Behaviours, id: string, value: Variant) =
  let b = self.find(id)
  if b == nil: return

  var changed = true
  if b of ValueBehaviour:
    let vb = cast[ValueBehaviour](b)
    changed = (vb.valueInternal != value)

  b.set(value)
  if self.registry.hasKey(id):
    self.registry[id].isSet = true

  self.performAutoDispatch(b, changed)

proc setDynamic*(self: Behaviours, id: string, value: Variant) =
  let b = self.find(id)
  if b == nil: return

  var changed = true
  if b of ValueBehaviour:
    let vb = cast[ValueBehaviour](b)
    changed = (vb.valueInternal != value)

  b.setDynamic(value)
  if self.registry.hasKey(id):
    self.registry[id].isSet = true

  self.performAutoDispatch(b, changed)

proc softSet*(self: Behaviours, id: string, value: Variant) =
  let b = self.find(id)
  if b != nil and b of ValueBehaviour:
    cast[ValueBehaviour](b).valueInternal = value

proc performAutoDispatch(self: Behaviours, b: Behaviour, changed: bool) =
  if not self.component.isReadyInternal:
    self.autoDispatch[b] = changed
    return

  let autoDispatch = b.getConfigValue("autoDispatch")
  if autoDispatch != "":
    # Logic to dispatch event based on string name
    discard

proc ready*(self: Behaviours) =
  if self.autoDispatch.len == 0:
    return

  for b, changed in self.autoDispatch:
    self.performAutoDispatch(b, changed)

  self.autoDispatch.clear()

proc get*(self: Behaviours, id: string): Variant =
  let b = self.find(id)
  if b != nil:
    let info = self.registry[id]
    if not info.isSet and info.defaultValue.kind != vkNull:
      return info.defaultValue
    else:
      return b.get()
  return toVariant(nil)

proc getDynamic*(self: Behaviours, id: string): Variant =
  let b = self.find(id)
  if b != nil:
    return b.getDynamic()
  return toVariant(nil)

proc call*(self: Behaviours, id: string, param: Variant = toVariant(nil)): Variant =
  let b = self.find(id)
  if b != nil:
    return b.call(param)
  return toVariant(nil)

proc applyDefaults*(self: Behaviours) =
  var order = self.updateOrderInternal
  for key in self.registry.keys:
    if not order.contains(key):
      order.add(key)

  for key in order:
    let r = self.registry[key]
    if r.defaultValue.kind != vkNull:
      self.set(key, r.defaultValue)

proc replaceNative*(self: Behaviours) =
  # Native config integration
  discard
