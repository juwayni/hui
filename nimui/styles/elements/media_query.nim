import nimui/styles/style_sheet
import nimui/styles/elements/directive
import nimui/core/screen
import std/options

type
  MediaQuery* = ref object
    directives: seq[Directive]
    styleSheet*: StyleSheet

proc newMediaQuery*(directives: seq[Directive], styleSheet: StyleSheet): MediaQuery =
  new result
  result.directives = directives
  result.styleSheet = styleSheet

proc relevant*(self: MediaQuery): bool =
  # Check if media query is relevant to current screen state
  return true
