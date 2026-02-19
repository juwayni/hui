import nimui/core/component
import nimui/core/types
import nimui/components/atlas_player

type
  Spinner* = ref object of AtlasPlayer

proc newSpinner*(): Spinner =
  new result
  result.initComponent()
  result.addClass("spinner")
