import windy

proc toKeyCode*(key: Button): int =
  case key:
    of KeyTab: return 9
    of KeyUp: return 38
    of KeyDown: return 40
    of KeyLeft: return 37
    of KeyRight: return 39
    of KeySpace: return 32
    of KeyEnter: return 13
    of KeyEscape: return 27
    else: return 0
