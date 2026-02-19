import nimui/backend/assets_impl
import nimui/backend/toolkit_options
import nimui/assets/font_info
import nimui/assets/image_info
import nimui/assets/asset_plugin
import nimui/util/callback_map
import nimui/preloader
import std/tables
import std/options

type
  ToolkitAssets* = ref object of AssetsImpl
    preloadList*: seq[PreloadItem]
    options*: ToolkitOptions
    fontCache: TableRef[string, FontInfo]
    fontCallbacks: CallbackMap[FontInfo]
    imageCache: TableRef[string, ImageInfo]
    imageCallbacks: CallbackMap[ImageInfo]
    plugins: seq[AssetPlugin]

var gInstance: ToolkitAssets

proc instance*(): ToolkitAssets =
  if gInstance == nil:
    gInstance = ToolkitAssets()
    gInstance.preloadList = @[]
    gInstance.fontCache = newTable[string, FontInfo]()
    gInstance.fontCallbacks = newCallbackMap[FontInfo]()
    gInstance.imageCache = newTable[string, ImageInfo]()
    gInstance.imageCallbacks = newCallbackMap[ImageInfo]()
    gInstance.plugins = @[]
  return gInstance

proc runPlugins(self: ToolkitAssets, asset: string): string =
  var res = asset
  for p in self.plugins:
    # AssetPlugin should have an invoke method
    discard
  return res

proc getFont*(self: ToolkitAssets, resourceId: string, callback: proc(info: FontInfo) {.gcsafe.}, useCache: bool = true) =
  if useCache and self.fontCache.hasKey(resourceId):
    callback(self.fontCache[resourceId])
  else:
    discard self.fontCallbacks.add(resourceId, callback)
    if self.fontCallbacks.count(resourceId) == 1:
      self.getFontInternal(resourceId, proc(font: FontInfo) =
        if font != nil:
          self.fontCache[resourceId] = font
          self.fontCallbacks.invokeAndRemove(resourceId, font)
        else:
          # Check Haxe resources equivalent in Nim?
          discard self.fontCallbacks.remove(resourceId, callback)
          callback(nil)
      )

proc cacheImage*(self: ToolkitAssets, resourceId: string, imageInfo: ImageInfo) =
  if imageInfo == nil or resourceId == "": return
  self.imageCache[resourceId] = imageInfo

proc getCachedImage*(self: ToolkitAssets, resourceId: string): ImageInfo =
  if self.imageCache.hasKey(resourceId):
    return self.imageCache[resourceId]
  return nil

proc getImage*(self: ToolkitAssets, resourceId: string, callback: proc(info: ImageInfo) {.gcsafe.}, useCache: bool = true) =
  let processedId = self.runPlugins(resourceId)
  if useCache and self.imageCache.hasKey(processedId):
    callback(self.imageCache[processedId])
  else:
    discard self.imageCallbacks.add(processedId, callback)
    if self.imageCallbacks.count(processedId) == 1:
      self.getImageInternal(processedId, proc(imageInfo: ImageInfo) =
        if imageInfo != nil:
          self.imageCache[processedId] = imageInfo
          self.imageCallbacks.invokeAndRemove(processedId, imageInfo)
        else:
          discard self.imageCallbacks.remove(processedId, callback)
          callback(nil)
      )

proc getText*(self: ToolkitAssets, resourceId: string): string =
  # self.getTextDelegate(resourceId) equivalent
  return ""

proc addPlugin*(self: ToolkitAssets, plugin: AssetPlugin) =
  self.plugins.add(plugin)
