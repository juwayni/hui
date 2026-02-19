import ./data_source, ./transformation/iitem_transformer, ../util/variant, ../constants/sort_direction, algorithm

type
  ArrayDataSource*[T] = ref object of DataSource[T]
    array: seq[T]
    filteredArray: seq[T]

proc newArrayDataSource*[T](transformer: IItemTransformer[T] = nil): ArrayDataSource[T] =
  result = ArrayDataSource[T](array: @[], filteredArray: @[])
  initDataSource(result, transformer)

method handleClearFilter*[T](self: ArrayDataSource[T]) =
  if self.filteredArray.len == 0: return
  self.filteredArray = @[]
  self.handleChanged()

method handleFilter*[T](self: ArrayDataSource[T], fn: proc(index: int, item: T): bool {.gcsafe.}) =
  self.filteredArray = @[]
  for i, item in self.array:
    if fn(i, item):
      self.filteredArray.add(item)
  self.handleChanged()

method handleSort*[T](self: ArrayDataSource[T], fn: proc(o1: T, o2: T, direction: SortDirection): int {.gcsafe.}, direction: SortDirection) =
  let cmp = proc(a, b: T): int =
    return fn(a, b, direction)

  self.array.sort(cmp)
  if self.filteredArray.len > 0:
    self.filteredArray.sort(cmp)

method handleGetSize*[T](self: ArrayDataSource[T]): int =
  if self.filterFn != nil:
    return self.filteredArray.len
  return self.array.len

method handleGetItem*[T](self: ArrayDataSource[T], index: int): T =
  if self.filterFn != nil:
    return self.filteredArray[index]
  return self.array[index]

method handleIndexOf*[T](self: ArrayDataSource[T], item: T): int =
  if self.filterFn != nil:
    return self.filteredArray.find(item)
  return self.array.find(item)

method handleAddItem*[T](self: ArrayDataSource[T], item: T): int =
  self.array.add(item)
  let index = self.array.len - 1
  if self.filterFn != nil:
    if self.filterFn(index, item):
      self.filteredArray.add(item)
  return index

method handleInsert*[T](self: ArrayDataSource[T], index: int, item: T): T =
  self.array.insert(item, index)
  if self.filterFn != nil:
    if self.filterFn(index, item):
      # Inserting into filtered array is harder if we want to maintain order.
      # For now simple add or re-filter
      self.handleFilter(self.filterFn)
  return item

method handleRemoveItem*[T](self: ArrayDataSource[T], item: T): T =
  let idx = self.array.find(item)
  if idx != -1:
    self.array.delete(idx)
  if self.filterFn != nil:
    let fIdx = self.filteredArray.find(item)
    if fIdx != -1:
      self.filteredArray.delete(fIdx)
  return item

method handleClear*[T](self: ArrayDataSource[T]) =
  self.array = @[]
  self.filteredArray = @[]

method handleGetData*[T](self: ArrayDataSource[T]): Variant =
  # Returning a seq as Variant is tricky. We'll return nil for now or implement seq to Variant
  return toVariant(nil)

method handleSetData*[T](self: ArrayDataSource[T], v: Variant) =
  # self.array = v.toSeq?
  discard

method handleUpdateItem*[T](self: ArrayDataSource[T], index: int, item: T): T =
  if self.filterFn != nil:
    self.filteredArray[index] = item
    # Need to find index in original array too?
    # This is why HaxeUI's ListDataSource/ArrayDataSource can be complex.
  else:
    self.array[index] = item
  return item

method clone*[T](self: ArrayDataSource[T]): DataSource[T] =
  let c = newArrayDataSource[T](self.transformer)
  c.array = self.array
  c.filteredArray = self.filteredArray
  # c.filterFn = self.filterFn # It's private in base class usually or we make it protected
  return c

proc fromArray*[T](source: seq[T], transformer: IItemTransformer[T] = nil): ArrayDataSource[T] =
  result = newArrayDataSource[T](transformer)
  result.array = source
