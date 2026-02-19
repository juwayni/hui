import nimui/util/event_dispatcher
import nimui/core/types
import nimui/navigation/route_details
import nimui/navigation/inavigatable_view
import std/tables
import std/strutils
import nimui/util/variant

type
  NavigationManager* = ref object of EventDispatcher
    defaultContainer*: Component
    subDomain*: string
    registeredRoutes: seq[RouteDetails]

var navigationManagerInstance: NavigationManager

proc instance*(): NavigationManager =
  if navigationManagerInstance == nil:
    new navigationManagerInstance
    navigationManagerInstance.initEventDispatcher()
    navigationManagerInstance.registeredRoutes = @[]
  return navigationManagerInstance

proc registerRoute*(self: NavigationManager, path: string, details: RouteDetails) =
  let copy = details.clone()
  copy.path = path
  self.registeredRoutes.add(copy)

proc navigateTo*(self: NavigationManager, path: string, params: Table[string, Variant] = initTable[string, Variant]()) =
  # Logic to find route and update container
  discard
