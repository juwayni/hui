import nimui/backend/backend_impl

type
  Backend* = object

proc id*(): string =
  backend_impl.id
