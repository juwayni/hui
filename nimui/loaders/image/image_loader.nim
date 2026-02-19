import nimui/loaders/image/image_loader_base
import nimui/assets/image_info
import nimui/util/variant
import std/tables
import std/strutils

type
  ImageLoaderInfo = object
    prefix: string
    pattern: string
    ctor: proc(): ImageLoaderBase {.gcsafe.}
    instance: ImageLoaderBase
    isDefault: bool
    singleInstance: bool

  ImageLoader* = ref object
    registeredLoaders: Table[string, ImageLoaderInfo]
    defaultLoader: ptr ImageLoaderInfo

var imageLoaderInstance: ImageLoader

proc instance*(): ImageLoader =
  if imageLoaderInstance == nil:
    new imageLoaderInstance
    imageLoaderInstance.registeredLoaders = initTable[string, ImageLoaderInfo]()
  return imageLoaderInstance

proc register*(self: ImageLoader, prefix: string, ctor: proc(): ImageLoaderBase {.gcsafe.}, pattern: string = "", isDefault: bool = false, singleInstance: bool = false) =
  var info = ImageLoaderInfo(
    prefix: prefix,
    pattern: pattern,
    ctor: ctor,
    isDefault: isDefault,
    singleInstance: singleInstance
  )
  self.registeredLoaders[prefix] = info
  if isDefault:
    # Need to store default properly
    discard

proc get*(self: ImageLoader, prefix: string, stringResource: string = ""): ImageLoaderBase =
  if self.registeredLoaders.hasKey(prefix):
    var info = self.registeredLoaders[prefix]
    if info.singleInstance and info.instance != nil:
      return info.instance
    let inst = info.ctor()
    if info.singleInstance:
      self.registeredLoaders[prefix].instance = inst
    return inst
  return nil

proc load*(self: ImageLoader, resource: Variant, callback: proc(info: ImageInfo) {.gcsafe.}, useCache: bool = true) =
  if resource.kind == vkString:
    let stringResource = resource.toString()
    let n = stringResource.find("://")
    var prefix = ""
    if n != -1:
      prefix = stringResource.substr(0, n - 1)

    let loader = self.get(prefix, stringResource)
    if loader != nil:
      loader.load(resource, callback)
    else:
      callback(nil)
  else:
    callback(nil)
