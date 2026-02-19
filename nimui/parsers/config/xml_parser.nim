import ./config_parser, ../../util/generic_config, tables, xmltree, xmlparser, strutils

type
  XMLParser* = ref object of ConfigParser

proc newXMLParser*(): XMLParser =
  new result

proc parseAdditionalConfig(node: XmlNode, parent: GenericConfig, defines: Table[string, string]) =
  if node.attrs != nil and node.attrs.hasKey("if"):
    let condition = "haxeui_" & node.attrs["if"]
    if not defines.hasKey(condition):
      return

  let group = parent.addSection(node.tag)
  if node.attrs != nil:
    for k, v in node.attrs:
      group.values[k] = v

  for child in node.children:
    if child.kind == xnElement:
      parseAdditionalConfig(child, group, defines)

method parse*(self: XMLParser, data: string, defines: Table[string, string]): GenericConfig =
  var config = newGenericConfig()
  let xml = parseXml(data)

  for child in xml.children:
    if child.kind == xnElement:
      parseAdditionalConfig(child, config, defines)

  return config

register("xml", proc(): ConfigParser = newXMLParser())
