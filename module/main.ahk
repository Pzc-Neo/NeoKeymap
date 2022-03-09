; 【通用】函数
#Include, module/core/common.ahk
; 【提示】函数：消息提示框等
#Include, module/core/tip.ahk
; 【本软件】函数：重启、退出等
#Include, module/core/app.ahk
; 【系统】函数：关机、重启等
#Include, module/core/system.ahk
; 【窗口】函数：切换窗口、激活窗口(软件没启动的时候就启动)等
#Include, module/core/win.ahk
; 【鼠标】函数：移动、点击等
#Include, module/core/mouse.ahk
#Include, module/core/shellRun.ahk
#Include, module/core/superMenu.ahk

postCharToTipWidnow(char) {
  oldValue := A_DetectHiddenWindows

  global CapslockAbbrCommandChar
  CapslockAbbrCommandChar := CapslockAbbrCommandChar char
  ; 转为大写(还是不转比较好，因为匹配的时候是没有转大写的。
  ; 有时候不小心输入大写，就会出现指令看上去正确，但是却没有执行的情况。 )
  ; StringUpper, CapslockAbbrCommandChar, CapslockAbbrCommandChar
  _ShowTip(CapslockAbbrCommandChar,60)

  DetectHiddenWindows, 1
  if WinExist("ahk_class MyKeymap_Typo_Window")
    PostMessage, 0x0102, Ord(char), 0
  DetectHiddenWindows, %oldValue%
}

postMessageToTipWidnow(messageType) {
  oldValue := A_DetectHiddenWindows
  DetectHiddenWindows, 1
  if WinExist("ahk_class MyKeymap_Typo_Window")
    PostMessage, %messageType%, 0, 0
  DetectHiddenWindows, %oldValue%
}

wp_GetMonitorAt(x, y, default=1)
{
  SysGet, m, MonitorCount
  ; Iterate through all monitors.
  Loop, %m%
  { ; Check if the window is on this monitor.
    SysGet, Mon, Monitor, %A_Index%
    if (x >= MonLeft && x <= MonRight && y >= MonTop && y <= MonBottom)
      return A_Index
  }

  return default
}

toggleCapslock() {
  ; 方案 2,  未测试
  send, {Blind}{Lctrl}{LAlt UP}{CapsLock}

  ; 方案 1,  输入法大小写指示可能不对
  ; newState := !GetKeyState("CapsLock", "T")
  ; SetCapsLockState %newState%
  ; if (newState)
  ;     tip("CapsLock 开启", -400)
  ; else
  ;     tip("CapsLock 关闭", -400)
}

surroundWithSpace(message) {
  return " " . message . " "
}

copySelectedText()
{
  ; old_clipboard := clipboardall
  clipboard =
  send ^c
  ; send ^{insert}
  clipwait, 0.5, 1

  if (errorlevel) {
    tip("copy text failed", -700)
    return ""
  }

  r := rtrim(clipboard, "`n")
  return r
}

addHtmlStyle(text, style )
{
  text := htmlEscape(text)

  if (instr(text, "`n")) 
    html = <span style="%style%"><pre>%text%</pre></span>
  else 
    html = <span style="%style%">%text%</span>

  return html
}

; modified from jackieku's code (http://www.autohotkey.com/forum/post-310959.html#310959)
UriEncode(Uri, Enc = "UTF-8")
{
  StrPutVar(Uri, Var, Enc)
  f := A_FormatInteger
  SetFormat, IntegerFast, H
  Loop
  {
    Code := NumGet(Var, A_Index - 1, "UChar")
    If (!Code)
      Break
    If (Code >= 0x30 && Code <= 0x39 ; 0-9
        || Code >= 0x41 && Code <= 0x5A ; A-Z
    || Code >= 0x61 && Code <= 0x7A) ; a-z
    Res .= Chr(Code)
    Else
      Res .= "%" . SubStr(Code + 0x100, -1)
  }
  SetFormat, IntegerFast, %f%
  Return, Res
}

StrPutVar(Str, ByRef Var, Enc = "")
{
  Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
  VarSetCapacity(Var, Len, 0)
  Return, StrPut(Str, &Var, Enc)
}

htmlEscape(text) 
{
  text := strReplace(text, "&", "&amp;")
    text := strReplace(text, "<", "&lt;")
      text := strReplace(text, ">", "&gt;")
        text := strReplace(text, """", "&quot;")
          text := strReplace(text, " ", "&nbsp;")
            return text
          }

          setHtml(html)
          {
            s := "<HTML> <head><meta http-equiv='Content-type' content='text/html;charset=UTF-8'></head> <body> <!--StartFragment-->"
            s .= html
            s .= "<!--EndFragment--></body></HTML> "
            dllcall("clip_dll.dll\setHtml", "Str", s)
          }

          setColor(color := "#000000", fontFamily:= "Iosevka") 
          {
            text := copySelectedText()
            if (!text) {
              return
            }

            style := "color: " color "; font-family: " fontFamily ";"
            html := addHtmlStyle(text, style)
            md := "<font color='{{color}}'>{{text}}</font>"

            if (WinActive(" - Typora")) {
              md := strReplace(md, "{{text}}", text)
              md := strReplace(md, "{{color}}", color)
              clipboard := md
            } else {
              ; sleep 200
              setHtml( html )
              ; sleep 300
              Sleep, 100
            }

            send {LShift down}{Insert down}{Insert up}{LShift up}
          }

          setHotkeyStatus(theHotkey, enableHotkey)
          {
            global allHotkeys
            for index,value in allHotkeys
            {
              if (value == theHotkey) {
                if (enableHotkey)
                  hotkey, %theHotkey%, on
                else
                  hotkey, %theHotkey%, off
              }
            }
          }

          disableOtherHotkey(thisHotkey)
          {
            global allHotkeys
            ; ToolTip, % thisHotkey
            for index,value in allHotkeys
            {
              if (value != thisHotkey) {
                hotkey, %value%, off
              }
            }

          }

          enableOtherHotkey(thisHotkey)
          {
            global allHotkeys
            ; ToolTip, % thisHotkey
            for index,value in allHotkeys
            {
              if (value != thisHotkey) {
                hotkey, %value%, on
              }
            }

          }

          enterJModeK()
          {
            global
            JModeK := true
            keywait o
            JModeK := false
          }

          enterJModeL()
          {
            global
            JModeL := true
            keywait l
            JModeL := false
          }