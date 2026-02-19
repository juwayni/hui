import nimui/containers/hbox

type
  Footer* = ref object of HBox

proc newFooter*(): Footer =
  new result
  initComponent(result)
  result.addClass("footer")
