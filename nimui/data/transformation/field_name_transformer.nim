import ./iitem_transformer, ../../util/variant, tables

type
  FieldNameTransformer* = ref object of IItemTransformer[Variant]
    mapping*: Table[string, string]

proc newFieldNameTransformer*(mapping: Table[string, string] = initTable[string, string]()): FieldNameTransformer =
  FieldNameTransformer(mapping: mapping)

method transformFrom*(self: FieldNameTransformer, i: Variant): Variant =
  if self.mapping.len == 0:
    return i

  if i.kind != vkTable:
    return i

  var o = i.table # This is a shallow copy of the table if we are not careful. Variant.table usually returns a ref to the table.
  # We should probably clone it.
  var cloned = newTable[string, Variant]()
  for k, v in o:
    cloned[k] = v

  for fromField, toField in self.mapping:
    if cloned.hasKey(fromField):
      let val = cloned[fromField]
      cloned.del(fromField)
      cloned[toField] = val

  return toVariant(cloned)
