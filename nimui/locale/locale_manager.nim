import nimui/core/types
import nimui/events/ui_event
import nimui/locale/locale_event
import nimui/util/event_map
import std/tables
import std/strutils
import std/options

type
  ComponentLocaleEntry = object
    callback: proc(): Variant {.gcsafe.}
    expr: string

  LocaleManager* = ref object
    eventMap: EventMap
    languageInternal: string
    localeSet: bool
    registeredComponents: Table[Component, Table[string, ComponentLocaleEntry]]
    localeMap: Table[string, Table[string, string]]

var localeManagerInstance: LocaleManager

proc instance*(): LocaleManager =
  if localeManagerInstance == nil:
    new localeManagerInstance
    localeManagerInstance.languageInternal = "en"
    localeManagerInstance.registeredComponents = initTable[Component, Table[string, ComponentLocaleEntry]]()
    localeManagerInstance.localeMap = initTable[string, Table[string, string]]()
  return localeManagerInstance

proc language*(self: LocaleManager): string = self.languageInternal
proc `language=`*(self: LocaleManager, value: string) =
  if value == "" or self.languageInternal == value: return
  self.languageInternal = value
  self.localeSet = true
  # applyLocale logic
  if self.eventMap != nil:
    self.eventMap.invoke(LocaleEventChanged, newLocaleEvent(LocaleEventChanged))

proc registerComponent*(self: LocaleManager, component: Component, prop: string, callback: proc(): Variant {.gcsafe.} = nil, expr: string = "") =
  if not self.registeredComponents.hasKey(component):
    self.registeredComponents[component] = initTable[string, ComponentLocaleEntry]()

  self.registeredComponents[component][prop] = ComponentLocaleEntry(callback: callback, expr: expr)
  # refreshFor(component)

proc unregisterComponent*(self: LocaleManager, component: Component) =
  self.registeredComponents.del(component)

proc addStrings*(self: LocaleManager, localeId: string, map: Table[string, string]) =
  let lid = localeId.replace("-", "_")
  if not self.localeMap.hasKey(lid):
    self.localeMap[lid] = initTable[string, string]()
  for k, v in map:
    self.localeMap[lid][k] = v

proc lookupString*(self: LocaleManager, id: string): string =
  let lang = self.language()
  if self.localeMap.hasKey(lang) and self.localeMap[lang].hasKey(id):
    return self.localeMap[lang][id]
  return id
