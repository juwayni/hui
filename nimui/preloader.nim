import nimui/core/component
import nimui/core/screen
import nimui/containers/box
import nimui/components/label
import std/options

type
  PreloadItem* = object
    `type`*: string
    resourceId*: string

  Preloader* = ref object of Box
    current: int
    max: int

proc newPreloader*(): Preloader =
  new result
  initComponent(result)
  result.id = "preloader"
  result.percentWidth = some(100.0)
  result.percentHeight = some(100.0)

proc progress*(self: Preloader, current: int, max: int) =
  self.current = current
  self.max = max
  # Label update logic placeholder

proc increment*(self: Preloader) =
  self.progress(self.current + 1, self.max)

proc complete*(self: Preloader) =
  discard instance().removeComponent(self)
