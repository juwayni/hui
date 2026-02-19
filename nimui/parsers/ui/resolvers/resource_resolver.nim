import tables, nimui/util/variant, strutils

type
  ResourceResolver* = ref object of RootObj
    paramsInternal*: TableRef[string, Variant]

proc newResourceResolver*(params: TableRef[string, Variant] = nil): ResourceResolver =
  ResourceResolver(paramsInternal: params)

method getResourceData*(self: ResourceResolver, r: string): string {.base.} =
  return ""

proc extension*(self: ResourceResolver, path: string): string =
  let n = path.find('.')
  if n == -1: return ""
  let arr = path.split('.')
  return arr[arr.len - 1]
