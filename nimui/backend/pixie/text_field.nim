import nimui/backend/font_data
import nimui/backend/pixie/scissor_helper
import nimui/geom/rectangle
import pixie
import vmath
import strutils
import unicode

type
  CharPosition* = object
    row*: int
    column*: int

  CaretInfo* = object
    row*, column*: int
    visible*, force*: bool
    timerId*: int

  SelectionInfo* = object
    start*: CharPosition
    `end`*: CharPosition

  TextField* = ref object
    id*: string
    selectionInfo: SelectionInfo
    caretInfo: CaretInfo
    left*, top*: float
    width*, height*: float
    editable*: bool
    textColor*, backgroundColor*: Color
    selectedTextColor*, selectedBackgroundColor*: Color
    scrollTop*, scrollLeft*: float
    text*: string
    lines: seq[seq[int]] # Codepoints
    font*: FontData
    fontSize*: int
    multiline*: bool
    wordWrap*: bool
    autoHeight*: bool

proc newTextField*(): TextField =
  TextField(
    width: 200, height: 100,
    editable: true,
    textColor: Color(r:0, g:0, b:0, a:255),
    backgroundColor: Color(r:255, g:255, b:255, a:255),
    selectedTextColor: Color(r:255, g:255, b:255, a:255),
    selectedBackgroundColor: Color(r:51, g:144, b:255, a:255),
    fontSize: 14,
    multiline: true,
    wordWrap: true,
    text: ""
  )

proc splitLines(self: TextField) =
  self.lines = @[]
  if self.text == "" or self.font == nil:
    return

  if not self.multiline:
    var t = self.text.replace("\n", "").replace("\r", "")
    if self.password:
      t = "*".repeat(t.len)
    var cps: seq[int] = @[]
    for rune in t.runes:
      cps.add(rune.int)
    self.lines.add(cps)
  elif not self.wordWrap:
    let arr = self.text.replace("\r\n", "\n").replace("\r", "\n").split('\n')
    for a in arr:
      var cps: seq[int] = @[]
      for rune in a.runes:
        cps.add(rune.int)
      self.lines.add(cps)
  else:
    # Word wrap logic
    var totalWidth = 0.0
    var spaceIndex = -1
    var start = 0
    let runes = self.text.toRunes()
    var currentLine: seq[int] = @[]

    for i in 0 ..< runes.len:
      let rune = runes[i]
      let charCode = rune.int
      if charCode == 32: # SPACE
        spaceIndex = i
      elif charCode == 10 or charCode == 13: # CR or LF
        self.lines.add(currentLine)
        currentLine = @[]
        totalWidth = 0
        spaceIndex = -1
        continue

      let charWidth = self.font.size # Simplified: pixie font size as width per char for now
      # In real implementation we'd use font.widthOf(rune)

      if totalWidth + charWidth > self.width:
        # Simplified wrap at space
        self.lines.add(currentLine)
        currentLine = @[]
        totalWidth = charWidth
        currentLine.add(charCode)
      else:
        totalWidth += charWidth
        currentLine.add(charCode)

    if currentLine.len > 0:
      self.lines.add(currentLine)

proc recalc*(self: TextField) =
  self.splitLines()
  if self.autoHeight and self.font != nil:
    # Approximate
    self.height = self.lines.len.float * self.font.size

proc render*(self: TextField, ctx: Context) =
  if self.font == nil: return

  ctx.fillStyle = self.backgroundColor
  ctx.fillRect(rect(self.left, self.top, self.width, self.height))

  pushScissor(ctx, self.left.int, self.top.int, self.width.int, self.height.int)

  var ypos = self.top
  for cps in self.lines:
    var lineStr = ""
    for cp in cps:
      lineStr.add(Rune(cp).toUTF8())

    ctx.image.fillText(self.font, lineStr, translate(vec2(self.left - self.scrollLeft, ypos)))
    ypos += self.font.size

  popScissor(ctx)
