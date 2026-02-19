import ./filter, ../styles/css_filters, ../util/variant

proc parseFilter*(filterDetails: seq[Variant]): Filter =
  var details = filterDetails
  if details.len == 0: return nil

  let filterName = details[0].toString()
  details.delete(0)

  if not hasCssFilter(filterName):
    return nil

  let ctor = getCssFilter(filterName)
  let filter = ctor()
  filter.parse(details)
  return filter
