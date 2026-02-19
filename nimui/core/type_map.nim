import ../util/rtti

proc getTypeInfo*(className, property: string): string =
  let propInfo = getClassProperty(className, property)
  return propInfo.propertyType
