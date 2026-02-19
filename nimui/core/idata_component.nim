import ../data/data_source, ../util/variant

type
  IDataComponent* = ref object of RootObj

method dataSource*(self: IDataComponent): DataSource[Variant] {.base.} = discard
method `dataSource=`*(self: IDataComponent, value: DataSource[Variant]) {.base.} = discard
