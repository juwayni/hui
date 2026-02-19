import macros
import std/strutils
import std/os
import nimui/parsers/ui/xml_parser
import nimui/core/types
import nimui/util/string_util

macro buildComponent*(path: static string): untyped =
  # Read XML at compile time
  # Parse it
  # Generate Nim code to create components
  let content = readFile(path)
  # let info = parseXml(content) # Need to call the parser at compile time

  # For now, just a placeholder that returns a new Component
  # result = quote do:
  #   newComponent()
  result = newCall(ident("newComponent"))

macro buildFromString*(source: static string): untyped =
  result = newCall(ident("newComponent"))

proc cascadeStylesTo*(id: string, styleProperties: seq[string]) =
  discard
