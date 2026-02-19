import nimui/data/data_source
import nimui/util/variant
import json, strutils, xmltree, xmlparser

type
  DataSourceFactory*[T] = ref object

proc newDataSourceFactory*[T](): DataSourceFactory[T] =
  new result

proc create*[T](self: DataSourceFactory[T], typeProc: proc(): DataSource[T]): DataSource[T] =
  return typeProc()

proc xml2Object(el: XmlNode, addId: bool = true): Variant =
  # Very simplified xml to variant object mapping
  # In actual HaxeUI it builds a Dynamic object
  return Variant(kind: vkNull)

proc fromString*[T](self: DataSourceFactory[T], data: string, typeProc: proc(): DataSource[T]): DataSource[T] =
  let ds = self.create(typeProc)
  if data.startsWith("<"):
    let xml = parseXml(data)
    # ... logic to add from xml
  elif data.startsWith("["):
    let j = parseJson(data.replace("'", "\""))
    # ... logic to add from json
  return ds
