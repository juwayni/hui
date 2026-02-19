import ./module, ./module_parser, tables, strutils, xmltree, xmlparser, std/options

type
  XMLParser* = ref object of ModuleParser

proc newXMLParser*(): XMLParser =
  new result

proc checkCondition(node: XmlNode, defines: Table[string, string]): bool =
  if node.attrs != nil:
    if node.attrs.hasKey("if"):
      return defines.hasKey(node.attrs["if"])
    elif node.attrs.hasKey("unless"):
      return not defines.hasKey(node.attrs["unless"])
  return true

proc parseResources(el: XmlNode, m: Module, defines: Table[string, string]) =
  if el.attrs != nil and el.attrs.hasKey("exclude"):
    ModuleResourceEntry_globalExclusions.add(el.attrs["exclude"])

  for child in el.findAll("exclude"):
    if checkCondition(child, defines):
      if child.attrs != nil and child.attrs.hasKey("pattern"):
        ModuleResourceEntry_globalExclusions.add(child.attrs["pattern"])

  if el.attrs != nil and el.attrs.hasKey("include"):
    ModuleResourceEntry_globalInclusions.add(el.attrs["include"])

  for child in el.findAll("include"):
    if checkCondition(child, defines):
      if child.attrs != nil and child.attrs.hasKey("pattern"):
        ModuleResourceEntry_globalInclusions.add(child.attrs["pattern"])

  for resourceNode in el.findAll("resource"):
    if checkCondition(resourceNode, defines):
      var entry = ModuleResourceEntry(
        path: resourceNode.attr("path"),
        prefix: resourceNode.attr("prefix"),
        exclusions: @[],
        inclusions: @[]
      )
      if resourceNode.attrs != nil and resourceNode.attrs.hasKey("exclude"):
        entry.exclusions.add(resourceNode.attrs["exclude"])
      for exc in resourceNode.findAll("exclude"):
        if checkCondition(exc, defines):
          entry.exclusions.add(exc.attr("pattern"))

      if resourceNode.attrs != nil and resourceNode.attrs.hasKey("include"):
        entry.inclusions.add(resourceNode.attrs["include"])
      for inc in resourceNode.findAll("include"):
        if checkCondition(inc, defines):
          entry.inclusions.add(inc.attr("pattern"))

      m.resourceEntries.add(entry)

proc parseComponents(el: XmlNode, m: Module, defines: Table[string, string]) =
  for node in el.children:
    if node.kind != xnElement: continue
    if (node.tag == "class" or node.tag == "component") and checkCondition(node, defines):
      var entry = ModuleComponentEntry()
      entry.classPackage = node.attr("package")
      entry.className = if node.tag == "class": node.attr("name") else: node.attr("class")
      entry.classFolder = node.attr("folder")
      entry.classFile = node.attr("file")
      if node.attrs != nil and node.attrs.hasKey("loadAll"):
        entry.loadAll = node.attrs["loadAll"] == "true"
      m.componentEntries.add(entry)

proc parseLayouts(el: XmlNode, m: Module, defines: Table[string, string]) =
  for node in el.findAll("class"):
    if checkCondition(node, defines):
      var entry = ModuleLayoutEntry()
      entry.classPackage = node.attr("package")
      entry.className = node.attr("name")
      m.layoutEntries.add(entry)

proc parseThemes(el: XmlNode, m: Module, defines: Table[string, string], context: string) =
  for themeNode in el.children:
    if themeNode.kind != xnElement: continue
    if not checkCondition(themeNode, defines): continue

    var theme = ModuleThemeEntry(
      name: themeNode.tag,
      parent: themeNode.attr("parent"),
      styles: @[],
      vars: initTable[string, string](),
      images: @[]
    )

    var lastStylePriority = none(float)
    for styleNode in themeNode.findAll("style"):
      if not checkCondition(styleNode, defines): continue
      var styleEntry = ModuleThemeStyleEntry()
      styleEntry.resource = styleNode.attr("resource")
      if styleNode.len > 0:
        styleEntry.styleData = styleNode.innerText

      if styleNode.attrs != nil and styleNode.attrs.hasKey("priority"):
        styleEntry.priority = parseFloat(styleNode.attrs["priority"])
        lastStylePriority = some(styleEntry.priority)
      elif lastStylePriority.isSome:
        lastStylePriority = some(lastStylePriority.get() + 0.01)
        styleEntry.priority = lastStylePriority.get()
      elif context.contains("haxe/ui/backend/"):
        styleEntry.priority = if theme.name == "global": -2.0 else: -1.0
        lastStylePriority = some(styleEntry.priority)

      theme.styles.add(styleEntry)

    for varNode in themeNode.findAll("var"):
      if checkCondition(varNode, defines):
        theme.vars[varNode.attr("name")] = varNode.attr("value")

    var lastImagePriority = none(float)
    for imageNode in themeNode.children:
      if imageNode.kind != xnElement: continue
      if not checkCondition(imageNode, defines): continue
      if imageNode.tag != "image" and imageNode.tag != "icon": continue

      var imageEntry = ModuleThemeImageEntry()
      imageEntry.id = imageNode.attr("id")
      imageEntry.resource = imageNode.attr("resource")

      if imageNode.attrs != nil and imageNode.attrs.hasKey("priority"):
        imageEntry.priority = parseFloat(imageNode.attrs["priority"])
        lastImagePriority = some(imageEntry.priority)
      elif lastImagePriority.isSome:
        lastImagePriority = some(lastImagePriority.get() + 0.01)
        imageEntry.priority = lastImagePriority.get()
      elif context.contains("haxe/ui/backend/"):
        imageEntry.priority = if theme.name == "global": -2.0 else: -1.0
        lastImagePriority = some(imageEntry.priority)

      theme.images.add(imageEntry)

    m.themeEntries[theme.name] = theme

proc parseProperties(el: XmlNode, m: Module, defines: Table[string, string]) =
  for node in el.findAll("property"):
    if checkCondition(node, defines):
      m.properties.add(ModulePropertyEntry(name: node.attr("name"), value: node.attr("value")))

proc parsePreloader(el: XmlNode, m: Module, defines: Table[string, string]) =
  for node in el.children:
    if node.kind != xnElement: continue
    if checkCondition(node, defines):
      m.preload.add(ModulePreloadEntry(`type`: node.tag, id: node.attr("id")))

proc parseLocales(el: XmlNode, m: Module, defines: Table[string, string]) =
  for node in el.children:
    if node.kind != xnElement: continue
    if checkCondition(node, defines):
      var entry = ModuleLocaleEntry(id: node.attr("id"), resources: @[])
      if node.attrs != nil and node.attrs.hasKey("resource"):
        entry.resources.add(node.attrs["resource"])
      for res in node.findAll("resource"):
        entry.resources.add(res.attr("path"))
      m.locales.add(entry)

proc parseValidators(el: XmlNode, m: Module, defines: Table[string, string]) =
  for node in el.findAll("validator"):
    if not checkCondition(node, defines): continue
    var entry = ModuleValidatorEntry(properties: initTable[string, string]())
    entry.id = node.attr("id")
    entry.className = node.attr("class")
    if node.attrs != nil:
      for k, v in node.attrs:
        if k != "id" and k != "class":
          entry.properties[k] = v
    m.validators.add(entry)

method parse*(self: XMLParser, data: string, defines: Table[string, string], context: string = ""): Module =
  var m = newModule()
  let xml = parseXml(data)
  let root = xml

  m.id = root.attr("id")
  m.preloader = root.attr("preloader")
  if root.attrs != nil and root.attrs.hasKey("priority"):
    try: m.priority = parseInt(root.attrs["priority"]) except: discard
  m.preloadList = root.attr("preload")

  for child in root.children:
    if child.kind != xnElement: continue
    if not checkCondition(child, defines): continue

    case child.tag:
      of "resources": parseResources(child, m, defines)
      of "components": parseComponents(child, m, defines)
      of "layouts": parseLayouts(child, m, defines)
      of "themes": parseThemes(child, m, defines, context)
      of "properties": parseProperties(child, m, defines)
      of "preload": parsePreloader(child, m, defines)
      of "locales": parseLocales(child, m, defines)
      of "validators": parseValidators(child, m, defines)
      of "cssExtensions":
        # parseCssFunctions, Filters, Directives
        discard
      else: discard

  return m
