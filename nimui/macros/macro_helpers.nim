import std/os
import std/macros

type
  ClassPathEntry* = object
    base*: string
    path*: string
    priority*: int

proc resolveFile*(file: string): string =
  if fileExists(file): return file
  # Search in current dir or assets
  return ""

proc extension*(path: string): string =
  let (_, _, ext) = splitFile(path)
  if ext.len > 0: return ext[1..^1] # remove dot
  return ""
