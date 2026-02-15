import nimui/backend/backend_impl

type
  Backend* = ref object of BackendImpl

proc id*(): string =
  return backendId
