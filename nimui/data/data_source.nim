import ../constants/sort_direction, ./transformation/iitem_transformer, ./idata_item, ../util/variant, strutils, re, algorithm, tables

type
  DataSource*[T] = ref object of RootObj
    onDataSourceChange*: proc() {.gcsafe.}
    transformer*: IItemTransformer[T]
    changed: bool
    allowCallbacksInternal: bool

    onAdd*: proc(item: T) {.gcsafe.}
    onInsert*: proc(index: int, item: T) {.gcsafe.}
    onUpdate*: proc(index: int, item: T) {.gcsafe.}
    onRemove*: proc(index: int, item: T) {.gcsafe.}
    onClear*: proc() {.gcsafe.}
    onChange*: proc() {.gcsafe.}

    filterFn*: proc(index: int, item: T): bool {.gcsafe.}
    currentSortFn*: proc(o1: T, o2: T, direction: SortDirection): int {.gcsafe.}
    currentSortDirection: SortDirection

proc initDataSource*[T](self: DataSource[T], transformer: IItemTransformer[T] = nil) =
  self.transformer = transformer
  self.allowCallbacksInternal = true
  self.changed = false

proc onInternalChange*[T](self: DataSource[T]) =
  if self.onDataSourceChange != nil: self.onDataSourceChange()
  if self.onChange != nil: self.onChange()

proc allowCallbacks*[T](self: DataSource[T]): bool = self.allowCallbacksInternal
proc `allowCallbacks=`*[T](self: DataSource[T], value: bool) =
  self.allowCallbacksInternal = value
  if self.allowCallbacksInternal and self.changed:
    self.changed = false
    self.onInternalChange()

# handle methods (to be overridden)
method handleGetSize*[T](self: DataSource[T]): int {.base.} = return 0
method handleGetItem*[T](self: DataSource[T], index: int): T {.base.} = discard
method handleIndexOf*[T](self: DataSource[T], item: T): int {.base.} = return -1
method handleAddItem*[T](self: DataSource[T], item: T): int {.base.} = return -1
method handleInsert*[T](self: DataSource[T], index: int, item: T): T {.base.} = discard
method handleRemoveItem*[T](self: DataSource[T], item: T): T {.base.} = discard
method handleUpdateItem*[T](self: DataSource[T], index: int, item: T): T {.base.} = discard
method handleGetData*[T](self: DataSource[T]): Variant {.base.} = return toVariant(nil)
method handleSetData*[T](self: DataSource[T], v: Variant) {.base.} = discard
method handleClear*[T](self: DataSource[T]) {.base.} = discard
method handleClearFilter*[T](self: DataSource[T]) {.base.} = discard
method handleFilter*[T](self: DataSource[T], fn: proc(index: int, item: T): bool {.gcsafe.}) {.base.} = discard
method handleSort*[T](self: DataSource[T], fn: proc(o1: T, o2: T, direction: SortDirection): int {.gcsafe.}, direction: SortDirection) {.base.} = discard

proc onDataItemChange*[T](self: DataSource[T]) =
  if self.filterFn != nil:
    self.handleFilter(self.filterFn)
  else:
    self.onInternalChange()

proc handleChanged*[T](self: DataSource[T]) =
  self.changed = true
  if self.currentSortFn != nil:
    self.handleSort(self.currentSortFn, self.currentSortDirection)
  if self.allowCallbacksInternal:
    self.changed = false
    self.onInternalChange()

proc size*[T](self: DataSource[T]): int = self.handleGetSize()

proc get*[T](self: DataSource[T], index: int): T =
  var r = self.handleGetItem(index)
  # In Nim, checking for interface is different. We'll assume T might inherit from IDataItem if we use ref objects
  when T is IDataItem:
    if r != nil:
      r.onDataSourceChanged = proc() = self.onDataItemChange()

  if self.transformer != nil:
    r = self.transformer.transformFrom(toVariant(r))
  return r

proc indexOf*[T](self: DataSource[T], item: T): int =
  var searchItem = item
  # transformer.transformFrom usually goes from dynamic to T.
  # Haxe code: if (transformer != null) { item = transformer.transformFrom(item); }
  # But indexOf usually takes the T that the user has.
  return self.handleIndexOf(searchItem)

proc add*[T](self: DataSource[T], item: T): int =
  let index = self.handleAddItem(item)
  self.handleChanged()
  if self.allowCallbacksInternal and self.onAdd != null:
    self.onAdd(item)
  return index

proc insert*[T](self: DataSource[T], index: int, item: T): T =
  let r = self.handleInsert(index, item)
  self.handleChanged()
  if self.allowCallbacksInternal and self.onInsert != null:
    self.onInsert(index, r)
  return r

proc remove*[T](self: DataSource[T], item: T): T =
  let index = self.indexOf(item)
  let r = self.handleRemoveItem(item)
  self.handleChanged()
  if self.allowCallbacksInternal and self.onRemove != nil:
    self.onRemove(index, r)
  return r

proc removeAt*[T](self: DataSource[T], index: int): T =
  let item = self.get(index)
  return self.remove(item)

proc removeAll*[T](self: DataSource[T]) =
  let original = self.allowCallbacksInternal
  self.allowCallbacksInternal = false
  while self.size() > 0:
    discard self.removeAt(0)
  self.allowCallbacksInternal = original
  self.handleChanged()

proc update*[T](self: DataSource[T], index: int, item: T): T =
  let r = self.handleUpdateItem(index, item)
  self.handleChanged()
  if self.allowCallbacksInternal and self.onUpdate != nil:
    self.onUpdate(index, r)
  return r

proc clear*[T](self: DataSource[T]) =
  let o = self.allowCallbacksInternal
  self.allowCallbacksInternal = false
  self.handleClear()
  self.allowCallbacksInternal = o
  self.handleChanged()
  if self.allowCallbacksInternal and self.onClear != nil:
    self.onClear()

proc clearFilter*[T](self: DataSource[T]) =
  self.filterFn = nil
  self.handleClearFilter()

proc filter*[T](self: DataSource[T], fn: proc(index: int, item: T): bool {.gcsafe.}) =
  self.filterFn = fn
  self.handleFilter(fn)

proc isFiltered*[T](self: DataSource[T]): bool = self.filterFn != nil

proc data*[T](self: DataSource[T]): Variant = self.handleGetData()
proc `data=`*[T](self: DataSource[T], v: Variant) =
  self.handleSetData(v)
  self.handleChanged()

proc sortCustom*[T](self: DataSource[T], fn: proc(o1: T, o2: T, direction: SortDirection): int {.gcsafe.}, direction: SortDirection = SortDirection.ASCENDING) =
  self.currentSortFn = fn
  self.currentSortDirection = direction
  self.handleSort(fn, direction)
  self.handleChanged()

# sortByFn helper
proc sortByFn*[T](o1: T, o2: T, direction: SortDirection, field: string): int =
  var f1: Variant
  var f2: Variant

  when T is Variant:
    f1 = o1
    f2 = o2
  else:
    # Fallback to string representation if we can't easily get field
    f1 = toVariant($o1)
    f2 = toVariant($o2)

  if field != "":
    if f1.kind == vkTable:
      f1 = f1.table.getOrDefault(field, toVariant(nil))
    if f2.kind == vkTable:
      f2 = f2.table.getOrDefault(field, toVariant(nil))

  if f1.kind == vkNull or f2.kind == vkNull:
    return 0

  let s1 = f1.toString()
  let s2 = f2.toString()

  var high = 1
  var low = -1
  if direction == SortDirection.DESCENDING:
    high = -1
    low = 1

  let alpha1 = s1.replace(re"[^a-zA-Z]", "")
  let alpha2 = s2.replace(re"[^a-zA-Z]", "")

  if alpha1 == alpha2:
    var n1 = 0
    var n2 = 0
    try: n1 = parseInt(s1.replace(re"[^0-9]", "")) except: discard
    try: n2 = parseInt(s2.replace(re"[^0-9]", "")) except: discard
    if n1 == n2: return 0
    return if n1 > n2: high else: low

  return if alpha1 > alpha2: high else: low

proc sort*[T](self: DataSource[T], field: string = "", direction: SortDirection = SortDirection.ASCENDING) =
  # In Haxe: sortCustom(sortByFn.bind(_, _, _, field), direction);
  let f = field
  self.sortCustom(proc(o1: T, o2: T, dir: SortDirection): int =
    return sortByFn(o1, o2, dir, f)
  , direction)

proc clone*[T](self: DataSource[T]): DataSource[T] =
  # Abstract
  return nil
