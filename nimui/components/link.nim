import nimui/core/component
import nimui/core/types
import nimui/components/label

type
  Link* = ref object of Label

proc newLink*(): Link =
  new result
  result.initComponent()
  result.addClass("link")
