import nimui/core/types
import nimui/navigation/inavigatable_view
import std/tables
import nimui/util/variant

type
  RouteDetails* = ref object
    viewCtor*: proc(): Component {.gcsafe.}
    path*: string
    initial*: bool
    error*: bool
    preserveView*: bool
    containerId*: string
    # container*: IComponentContainer
    component*: Component
    params*: Table[string, Variant]

proc newRouteDetails*(): RouteDetails =
  new result
  result.params = initTable[string, Variant]()

proc clone*(self: RouteDetails): RouteDetails =
  new result
  result.viewCtor = self.viewCtor
  result.path = self.path
  result.initial = self.initial
  result.error = self.error
  result.preserveView = self.preserveView
  result.containerId = self.containerId
  result.component = self.component
  result.params = self.params
