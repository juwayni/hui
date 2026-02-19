import tables, nimui/util/variant

type
  ModuleResourceEntry* = ref object
    path*: string
    prefix*: string
    exclusions*: seq[string]
    inclusions*: seq[string]

  ModuleClassEntry* = ref object of RootObj
    classPackage*: string
    className*: string
    classFolder*: string
    classFile*: string
    loadAll*: bool

  ModuleComponentEntry* = ref object of ModuleClassEntry
  ModuleLayoutEntry* = ref object of ModuleClassEntry

  ModuleThemeStyleEntry* = ref object
    resource*: string
    styleData*: string
    priority*: float

  ModuleThemeImageEntry* = ref object
    id*: string
    resource*: string
    priority*: float

  ModuleThemeEntry* = ref object
    name*: string
    parent*: string
    styles*: seq[ModuleThemeStyleEntry]
    images*: seq[ModuleThemeImageEntry]
    vars*: TableRef[string, string]

  ModulePropertyEntry* = ref object
    name*: string
    value*: string

  ModulePreloadEntry* = ref object
    `type`*: string
    id*: string

  ModuleLocaleEntry* = ref object
    id*: string
    resources*: seq[string]

  ModuleValidatorEntry* = ref object
    id*: string
    className*: string
    properties*: TableRef[string, Variant]

  ModuleActionInputSourceEntry* = ref object
    className*: string

  ModuleImageLoaderEntry* = ref object
    prefix*: string
    pattern*: string
    className*: string
    isDefault*: bool
    singleInstance*: bool

  ModuleCssFunctionEntry* = ref object
    name*: string
    call*: string

  ModuleCssFilterEntry* = ref object
    name*: string
    className*: string

  ModuleCssDirectiveEntry* = ref object
    name*: string
    className*: string

  Module* = ref object
    id*: string
    preloader*: string
    rootPath*: string
    classPath*: string
    priority*: int
    preloadList*: string
    resourceEntries*: seq[ModuleResourceEntry]
    componentEntries*: seq[ModuleComponentEntry]
    layoutEntries*: seq[ModuleLayoutEntry]
    themeEntries*: TableRef[string, ModuleThemeEntry]
    properties*: seq[ModulePropertyEntry]
    preload*: seq[ModulePreloadEntry]
    locales*: seq[ModuleLocaleEntry]
    validators*: seq[ModuleValidatorEntry]
    actionInputSources*: seq[ModuleActionInputSourceEntry]
    namespaces*: TableRef[string, string]
    imageLoaders*: seq[ModuleImageLoaderEntry]
    cssFunctions*: seq[ModuleCssFunctionEntry]
    cssFilters*: seq[ModuleCssFilterEntry]
    cssDirectives*: seq[ModuleCssDirectiveEntry]

const
  DefaultHaxeuiPrefix* = "core"
  DefaultHaxeuiNamespace* = "urn::haxeui::org"

proc newModule*(): Module =
  result = Module(
    resourceEntries: @[],
    componentEntries: @[],
    layoutEntries: @[],
    themeEntries: newTable[string, ModuleThemeEntry](),
    properties: @[],
    preload: @[],
    locales: @[],
    validators: @[],
    actionInputSources: @[],
    namespaces: newTable[string, string](),
    imageLoaders: @[],
    cssFunctions: @[],
    cssFilters: @[],
    cssDirectives: @[]
  )

proc validate*(self: Module) =
  if self.namespaces.len == 0:
    self.namespaces[DefaultHaxeuiPrefix] = DefaultHaxeuiNamespace

proc newModuleResourceEntry*(): ModuleResourceEntry =
  ModuleResourceEntry(exclusions: @[], inclusions: @[])

proc newModuleThemeEntry*(): ModuleThemeEntry =
  ModuleThemeEntry(styles: @[], images: @[], vars: newTable[string, string]())

proc newModuleValidatorEntry*(): ModuleValidatorEntry =
  ModuleValidatorEntry(properties: newTable[string, Variant]())
