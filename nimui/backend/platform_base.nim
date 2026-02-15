import os, strutils, times

type
  PlatformBase* = ref object of RootObj
    isMobileInternal*: bool

const
  KeyCodeTab* = 9
  KeyCodeUp* = 38
  KeyCodeDown* = 40
  KeyCodeLeft* = 37
  KeyCodeRight* = 39
  KeyCodeSpace* = 32
  KeyCodeEnter* = 13
  KeyCodeEscape* = 27

proc newPlatformBase*(): PlatformBase =
  PlatformBase(isMobileInternal: false)

proc isWindows*(self: PlatformBase): bool =
  hostOS == "windows"

proc isLinux*(self: PlatformBase): bool =
  hostOS == "linux"

proc isMac*(self: PlatformBase): bool =
  hostOS == "macosx"

proc isMobile*(self: PlatformBase): bool =
  # Logic to detect mobile if needed, for now use internal flag
  self.isMobileInternal

method getMetric*(self: PlatformBase, id: string): float {.base.} =
  return 0

method getColor*(self: PlatformBase, id: string): int {.base.} =
  return -1

method getSystemLocale*(self: PlatformBase): string {.base.} =
  return ""

method perf*(self: PlatformBase): float {.base.} =
  return cpuTime() * 1000

method getKeyCode*(self: PlatformBase, keyId: string): int {.base.} =
  case keyId:
    of "tab": return KeyCodeTab
    of "up": return KeyCodeUp
    of "down": return KeyCodeDown
    of "left": return KeyCodeLeft
    of "right": return KeyCodeRight
    of "space": return KeyCodeSpace
    of "enter": return KeyCodeEnter
    of "escape": return KeyCodeEscape
    else:
      if keyId.len > 0:
        return ord(keyId[0])
      else:
        return 0

proc KeyTab*(self: PlatformBase): int = self.getKeyCode("tab")
proc KeyUp*(self: PlatformBase): int = self.getKeyCode("up")
proc KeyDown*(self: PlatformBase): int = self.getKeyCode("down")
proc KeyLeft*(self: PlatformBase): int = self.getKeyCode("left")
proc KeyRight*(self: PlatformBase): int = self.getKeyCode("right")
proc KeySpace*(self: PlatformBase): int = self.getKeyCode("space")
proc KeyEnter*(self: PlatformBase): int = self.getKeyCode("enter")
proc KeyEscape*(self: PlatformBase): int = self.getKeyCode("escape")
