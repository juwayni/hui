import ./data_source, ./transformation/iitem_transformer, ../util/variant

type
  ListDataSource*[T] = ref object of DataSource[T]
    array: seq[T]

proc newListDataSource*[T](transformer: IItemTransformer[T] = nil): ListDataSource[T] =
  result = ListDataSource[T](array: @[])
  initDataSource(result, transformer)

method handleGetSize*[T](self: ListDataSource[T]): int =
  return self.array.len

method handleGetItem*[T](self: ListDataSource[T], index: int): T =
  return self.array[index]

method handleIndexOf*[T](self: ListDataSource[T], item: T): int =
  return self.array.find(item)

method handleAddItem*[T](self: ListDataSource[T], item: T): int =
  self.array.add(item)
  return self.array.len - 1

method handleInsert*[T](self: ListDataSource[T], index: int, item: T): T =
  self.array.insert(item, index)
  return item

method handleRemoveItem*[T](self: ListDataSource[T], item: T): T =
  let idx = self.array.find(item)
  if idx != -1:
    self.array.delete(idx)
  return item

method handleClear*[T](self: ListDataSource[T]) =
  self.array = @[]

method handleGetData*[T](self: ListDataSource[T]): Variant =
  return toVariant(nil)

method handleSetData*[T](self: ListDataSource[T], v: Variant) =
  discard

method handleUpdateItem*[T](self: ListDataSource[T], index: int, item: T): T =
  self.array[index] = item
  return item

method clone*[T](self: ListDataSource[T]): DataSource[T] =
  let c = newListDataSource[T](self.transformer)
  c.array = self.array
  return c

proc fromArray*[T](source: seq[T], transformer: IItemTransformer[T] = nil): ListDataSource[T] =
  result = newListDataSource[T](transformer)
  result.array = source
