type
  ImageSurface* = ref object of RootObj

proc newImageSurface*(): ImageSurface =
  ImageSurface()
