type
  EventType*[T] = distinct string

proc name*[T](n: string): EventType[T] =
  return EventType[T](n)

proc `$`*(et: EventType): string = string(et)
