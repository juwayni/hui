type
  IDataItem* = ref object of RootObj
    onDataSourceChanged*: proc() {.gcsafe.}
