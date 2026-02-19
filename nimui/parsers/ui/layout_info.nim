import tables

type
  LayoutInfo* = ref object
    `type`*: string
    properties*: TableRef[string, string]

proc newLayoutInfo*(): LayoutInfo =
  LayoutInfo(properties: newTable[string, string]())
