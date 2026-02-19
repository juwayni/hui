import std/tables
import std/strutils
import os

var gMap: TableRef[string, string] = nil

proc populate*()

proc getAll*(): TableRef[string, string] =
  populate()
  return gMap

proc set*(name: string, value: string, overwrite: bool = false) =
  populate()
  if not overwrite and gMap.hasKey(name): return
  gMap[name] = value

proc populate*() =
  if gMap != nil: return
  gMap = newTable[string, string]()

  # In Nim, we can use defined(windows) etc.
  when defined(windows): set("windows", "1")
  elif defined(linux): set("linux", "1")
  elif defined(macosx): set("mac", "1")

  set("backend", "pixie") # Default for NimUI

proc toObject*(): TableRef[string, string] =
  populate()
  return gMap
