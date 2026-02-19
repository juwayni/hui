import ./iitem_transformer, ../../util/variant

type
  NativeTypeTransformer* = ref object of IItemTransformer[Variant]

proc newNativeTypeTransformer*(): NativeTypeTransformer =
  new(result)

method transformFrom*(self: NativeTypeTransformer, i: Variant): Variant =
  if i.kind == vkString:
    var o = newVariantTable()
    o["text"] = i
    o["value"] = i
    return toVariant(o)
  elif i.kind in {vkInt, vkFloat, vkBool}:
    var o = newVariantTable()
    o["value"] = i
    return toVariant(o)
  return i
