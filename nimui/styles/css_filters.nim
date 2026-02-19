import tables, ./filter

type
  FilterCreator* = proc(): Filter {.gcsafe.}

var gCssFilters: Table[string, FilterCreator]

proc registerCssFilter*(name: string, ctor: FilterCreator) =
  gCssFilters[name] = ctor

proc hasCssFilter*(name: string): bool =
  return gCssFilters.hasKey(name)

proc getCssFilter*(name: string): FilterCreator =
  return gCssFilters.getOrDefault(name)
