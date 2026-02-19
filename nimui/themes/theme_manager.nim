import nimui/themes/theme
import nimui/util/event_map
import nimui/events/theme_event
import std/tables
import std/strutils
import std/algorithm

type
  ThemeManager* = ref object
    themes: Table[string, Theme]
    themeImages: Table[string, ThemeImageEntry]
    eventMap: EventMap
    currentThemeVars*: Table[string, string]

var themeManagerInstance: ThemeManager

proc instance*(): ThemeManager =
  if themeManagerInstance == nil:
    new themeManagerInstance
    themeManagerInstance.themes = initTable[string, Theme]()
    themeManagerInstance.themeImages = initTable[string, ThemeImageEntry]()
    themeManagerInstance.currentThemeVars = initTable[string, string]()
  return themeManagerInstance

proc getTheme*(self: ThemeManager, name: string): Theme =
  if not self.themes.hasKey(name):
    self.themes[name] = newTheme()
  return self.themes[name]

proc applyTheme*(self: ThemeManager, themeName: string) =
  # Porting applyTheme logic
  discard

proc image*(self: ThemeManager, id: string): string =
  if self.themeImages.hasKey(id):
    return self.themeImages[id].resourceId
  return ""
