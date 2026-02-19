import nimui/util/variant

type
  Filter* = ref object of RootObj

proc newFilter*(): Filter =
  new result

method parse*(self: Filter, filterDetails: seq[Variant]) {.base.} =
  discard

proc applyDefaults*(params: seq[Variant], defaults: seq[Variant]): seq[Variant] =
  var copy: seq[Variant] = @[]
  if defaults.len > 0:
    for p in defaults:
      copy.add(p)

  if params.len > 0:
    for n, p in params:
      if n < copy.len:
        copy[n] = p
      else:
        copy.add(p)
  return copy
