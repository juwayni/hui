type
  ComponentSurface* = ref object of RootObj

proc newComponentSurface*(): ComponentSurface =
  ComponentSurface()
