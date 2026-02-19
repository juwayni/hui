import json, os, tables

type
  ISettingsPersister* = ref object of RootObj

method set*(self: ISettingsPersister, name: string, value: string) {.base.} = discard
method get*(self: ISettingsPersister, name: string): string {.base.} = return ""

type
  FileSettingsPersister* = ref object of ISettingsPersister
    filename*: string

proc newFileSettingsPersister*(filename: string = "settings.json"): FileSettingsPersister =
  new result
  result.filename = filename

method load(self: FileSettingsPersister): JsonNode =
  if fileExists(self.filename):
    try:
      return parseFile(self.filename)
    except:
      return newJObject()
  return newJObject()

method save(self: FileSettingsPersister, data: JsonNode) =
  writeFile(self.filename, data.pretty())

method set*(self: FileSettingsPersister, name: string, value: string) =
  let data = self.load()
  data[name] = %value
  self.save(data)

method get*(self: FileSettingsPersister, name: string): string =
  let data = self.load()
  if data.hasKey(name):
    return data[name].getStr()
  return ""

type
  SettingsManager* = ref object
    persister: ISettingsPersister

var instanceInternal: SettingsManager

proc instance*(): SettingsManager =
  if instanceInternal == nil:
    instanceInternal = SettingsManager(persister: newFileSettingsPersister())
  return instanceInternal

proc set*(name: string, value: string) =
  instance().persister.set(name, value)

proc get*(name: string, defaultValue: string = ""): string =
  let v = instance().persister.get(name)
  if v == "": return defaultValue
  return v
