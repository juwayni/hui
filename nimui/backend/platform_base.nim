import std/os
import std/strutils
import std/times

const
  KEY_CODE_TAB* = 9
  KEY_CODE_UP* = 38
  KEY_CODE_DOWN* = 40
  KEY_CODE_LEFT* = 37
  KEY_CODE_RIGHT* = 39
  KEY_CODE_SPACE* = 32
  KEY_CODE_ENTER* = 13
  KEY_CODE_ESCAPE* = 27

type
  PlatformBase* = ref object of RootObj
    isMobileInternal*: bool
    isMobileCached*: bool

proc newPlatformBase*(): PlatformBase =
  new result

proc isWindows*(self: PlatformBase): bool =
  return hostOS == "windows"

proc isLinux*(self: PlatformBase): bool =
  return hostOS == "linux"

proc isMac*(self: PlatformBase): bool =
  return hostOS == "macosx"

proc isMobile*(self: PlatformBase): bool =
  if self.isMobileCached:
    return self.isMobileInternal

  # For now, non-js Nim is usually desktop
  self.isMobileInternal = false
  self.isMobileCached = true
  return self.isMobileInternal

method getMetric*(self: PlatformBase, id: string): float {.base.} =
  return 0.0

method getColor*(self: PlatformBase, id: string): int {.base.} =
  return -1

method getSystemLocale*(self: PlatformBase): string {.base.} =
  return ""

method perf*(self: PlatformBase): float {.base.} =
  return epochTime() * 1000.0

method getKeyCode*(self: PlatformBase, keyId: string): int {.base.} =
  case keyId.toLowerAscii():
    of "tab": return KEY_CODE_TAB
    of "up": return KEY_CODE_UP
    of "down": return KEY_CODE_DOWN
    of "left": return KEY_CODE_LEFT
    of "right": return KEY_CODE_RIGHT
    of "space": return KEY_CODE_SPACE
    of "enter": return KEY_CODE_ENTER
    of "escape": return KEY_CODE_ESCAPE
    else:
      if keyId.len > 0:
        return ord(keyId[0])
      return 0

proc KeyTab*(self: PlatformBase): int = self.getKeyCode("tab")
proc KeyUp*(self: PlatformBase): int = self.getKeyCode("up")
proc KeyDown*(self: PlatformBase): int = self.getKeyCode("down")
proc KeyLeft*(self: PlatformBase): int = self.getKeyCode("left")
proc KeyRight*(self: PlatformBase): int = self.getKeyCode("right")
proc KeySpace*(self: PlatformBase): int = self.getKeyCode("space")
proc KeyEnter*(self: PlatformBase): int = self.getKeyCode("enter")
proc KeyEscape*(self: PlatformBase): int = self.getKeyCode("escape")
