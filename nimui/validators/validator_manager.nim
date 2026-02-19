import tables, ../util/variant, ./ivalidator

type
  ValidatorCreator* = proc(): IValidator

  ValidatorItem = object
    ctor: ValidatorCreator
    defaultProperties: Table[string, Variant]

  ValidatorManager* = ref object
    registeredValidators: Table[string, ValidatorItem]

var gInstance: ValidatorManager

proc instance*(): ValidatorManager =
  if gInstance == nil:
    gInstance = ValidatorManager(registeredValidators: initTable[string, ValidatorItem]())
  return gInstance

proc registerValidator*(self: ValidatorManager, id: string, ctor: ValidatorCreator, defaultProperties: Table[string, Variant] = initTable[string, Variant]()) =
  self.registeredValidators[id] = ValidatorItem(
    ctor: ctor,
    defaultProperties: defaultProperties
  )

proc createValidator*(self: ValidatorManager, id: string, config: Variant = toVariant(nil)): IValidator =
  if not self.registeredValidators.hasKey(id):
    return nil

  let item = self.registeredValidators[id]
  let v = item.ctor()
  for k, val in item.defaultProperties:
    v.setProperty(k, val)
  return v
