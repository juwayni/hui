import tables, std/options, ./validator_info, ./component_style_info, ./layout_info, ../../util/string_util, strutils

type
  ComponentInfo* = ref object of RootObj
    filename*: string
    namespace*: string
    `type`*: string
    id*: string
    left*, top*, width*, height*: float
    percentWidth*, percentHeight*: Option[float]
    contentWidth*, contentHeight*: float
    percentContentWidth*, percentContentHeight*: Option[float]
    text*: string
    style*: string
    styleNames*: string
    composite*: bool
    layoutName*: string
    direction*: string
    data*: string
    parent*: ComponentInfo
    children*: seq[ComponentInfo]
    layout*: LayoutInfo
    properties*: Table[string, string]
    validators*: seq[ValidatorInfo]
    styles*: seq[ComponentStyleInfo]
    scriptlets*: seq[string]
    condition*: string
    resolvedClassName*: string

proc newComponentInfo*(): ComponentInfo =
  ComponentInfo(
    children: @[],
    properties: initTable[string, string](),
    validators: @[],
    styles: @[],
    scriptlets: @[]
  )

proc styleString*(self: ComponentInfo): string =
  if self.style == "": return ""
  return self.style.replace("\"", "'")

proc dataString*(self: ComponentInfo): string =
  if self.data == "": return ""
  return self.data.replace("\"", "'")

proc findRootComponent*(self: ComponentInfo): ComponentInfo =
  var r = self
  while r.parent != nil:
    r = r.parent
  return r

proc validate*(self: ComponentInfo) =
  var propsToRemove: seq[string] = @[]
  if self.layoutName != "" and self.layout == nil:
    self.layout = newLayoutInfo()
    self.layout.`type` = self.layoutName
    for propName, propValue in self.properties:
      if propName.startsWith("layout"):
        propsToRemove.add(propName)
        var newPropName = propName.replace("layout", "")
        newPropName = uncapitalizeFirstLetter(newPropName)
        self.layout.properties[newPropName] = propValue

  for p in propsToRemove:
    self.properties.del(p)
