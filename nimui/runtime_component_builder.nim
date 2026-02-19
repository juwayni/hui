import nimui/core/component
import nimui/toolkit
import nimui/toolkit_assets
import nimui/core/component_class_map
import nimui/core/component_field_map
import nimui/parsers/ui/component_parser
import nimui/parsers/ui/component_info
import nimui/parsers/ui/layout_info
import nimui/parsers/ui/resolvers/asset_resource_resolver
import nimui/parsers/ui/resolvers/resource_resolver
import nimui/util/variant
import nimui/styles/composite_style_sheet
import std/strutils
import std/tables

type
  RuntimeComponentBuilder* = object

proc buildComponentFromInfo*(c: ComponentInfo): Component

proc fromString*(data: string, `type`: string = "", resourceResolver: ResourceResolver = nil): Component =
  if data == "" or data.len == 0: return nil

  var actualType = `type`
  if actualType == "":
    if data.strip().startsWith("<"):
      actualType = "xml"

  let parser = ComponentParser.get(actualType)
  if parser == nil:
    return nil

  let info = parser.parse(data, resourceResolver)
  for style in info.styles:
    if style.scope == "global":
      Toolkit.styleSheet().parse(style.style)

  return buildComponentFromInfo(info)

proc fromAsset*(assetId: string): Component =
  let data = ToolkitAssets.instance().getText(assetId)
  return fromString(data, "xml", newAssetResourceResolver(assetId))

proc buildComponentFromInfo*(c: ComponentInfo): Component =
  let className = ComponentClassMap.get(c.`type`.toLowerAscii())
  if className == "":
    return nil

  # For now, we use a simple factory approach since Nim doesn't have RTTI for all types
  # We should use ComponentClassMap's factory if it has one
  # For now, create a base component as placeholder
  var component = newComponent()

  if c.id != "": component.id = c.id
  if c.left != 0: component.left = c.left
  if c.top != 0: component.top = c.top
  if c.width != 0: component.width = c.width
  if c.height != 0: component.height = c.height

  if c.percentWidth.isSome: component.percentWidth = c.percentWidth
  if c.percentHeight.isSome: component.percentHeight = c.percentHeight

  # properties
  for name, value in c.properties:
    let mappedName = mapField(name)
    component.setProperty(mappedName, toVariant(value))

  for childInfo in c.children:
    let child = buildComponentFromInfo(childInfo)
    if child != nil:
      discard component.addComponent(child)

  return component

proc build*(file: string): Component =
  return fromAsset(file)
