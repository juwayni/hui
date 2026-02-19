import nimui/loaders/image/image_loader_base
import nimui/assets/image_info
import nimui/util/variant
import nimui/toolkit
import std/httpclient
import std/asyncdispatch

type
  HttpImageLoader* = ref object of ImageLoaderBase

proc newHttpImageLoader*(): HttpImageLoader =
  new result

method load*(self: HttpImageLoader, resource: Variant, callback: proc(info: ImageInfo) {.gcsafe.}) =
  let url = resource.toString()

  # async loader
  # proc loadAsync() {.async.} =
  #   var client = newAsyncHttpClient()
  #   try:
  #     let response = await client.get(url)
  #     if response.status == "200 OK":
  #       let data = await response.body
  #       # Toolkit.assets.imageFromBytes(data, callback)
  #       discard
  #   finally:
  #     client.close()

  # For now, placeholder for network logic in Nim (requires async)
  callback(nil)
