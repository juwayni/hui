import tables
import nimui/util/variant

type
  ClassFactory*[T] = ref object
    generator*: proc(): T
    properties*: TableRef[string, Variant]

proc newClassFactory*[T](generator: proc(): T, properties: TableRef[string, Variant] = nil): ClassFactory[T] =
  new result
  result.generator = generator
  result.properties = properties

# We'll define this in a way that types can implement it
# and it can be called dynamically if needed.
# For now, we assume T has a `setProperty` method.
method setProperty*(self: RootObj, name: string, value: Variant) {.base.} =
  discard

proc newInstance*[T](self: ClassFactory[T]): T =
  let instance = self.generator()
  if self.properties != nil:
    for property, value in self.properties:
      # Use dynamic dispatch via method
      cast[RootObj](instance).setProperty(property, value)
  return instance
