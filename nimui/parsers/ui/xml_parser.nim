import ./component_parser, ./component_info, ./resolvers/resource_resolver, ./validator_info, ./component_style_info, tables, xmltree, xmlparser, strutils, std/options, ../../util/string_util

type
  XMLParser* = ref object of ComponentParser

proc newXMLParser*(): XMLParser =
  new result

proc preprocess(data: string): string =
  var res = data.replace("<script>", "<script><![CDATA[")
  res = res.replace("</script>", "]]></script>")
  return res

proc parseAttributes(component: ComponentInfo, node: XmlNode) =
  if node.attrs == nil: return
  for k, v in node.attrs:
    case k:
      of "condition": component.condition = v
      of "id": component.id = v
      of "left": component.left = parseFloatSafe(v)
      of "top": component.top = parseFloatSafe(v)
      of "width":
        if isPercentage(v): component.percentWidth = some(parseFloatSafe(v))
        else: component.width = parseFloatSafe(v)
      of "height":
        if isPercentage(v): component.percentHeight = some(parseFloatSafe(v))
        else: component.height = parseFloatSafe(v)
      of "text": component.text = v
      of "style": component.style = v
      else:
        component.properties[k] = v

proc parseComponent(self: XMLParser, component: ComponentInfo, node: XmlNode, resourceResolver: ResourceResolver): bool =
  # Very simplified for now, as ComponentInfo is not yet fully ported (139)
  component.type = node.tag.toLowerAscii().replace("-", "")
  parseAttributes(component, node)

  for childNode in node.children:
    if childNode.kind == xnElement:
      let childInfo = newComponentInfo()
      childInfo.parent = component
      if self.parseComponent(childInfo, childNode, resourceResolver):
        component.children.add(childInfo)

  return true

method parse*(self: XMLParser, data: string, resourceResolver: ResourceResolver = nil, fileName: string = ""): ComponentInfo =
  let preprocessed = preprocess(data)
  let xml = parseXml(preprocessed)

  var info = newComponentInfo()
  info.filename = fileName
  discard self.parseComponent(info, xml, resourceResolver)
  return info

register("xml", proc(): ComponentParser = newXMLParser())
