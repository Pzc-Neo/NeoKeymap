/* 
  操作窗口的函数
*/
; 最大化和还原 
toggleWinmaximize(){
  WinGet MX, MinMax, A
  If MX
    WinRestore A
  Else 
    WinMaximize A 
  return
}

winMinimizeIgnoreDesktop() 
{
  ; 如果是这个窗口是桌面就返回
  if (winactive("ahk_class WorkerW ahk_exe explorer.exe"))
    return
  ; if (winactive("ahk_class CabinetWClass ahk_exe explorer.exe"))
  ;     return
  if (winactive("ahk_exe Rainmeter.exe"))
    return

  WinMinimize, A
}

; 使当前窗口变成可移动状态
; 就是鼠标左键在窗口标题那里按住不放的状态
moveCurrentWindow()
{
  PostMessage, 0x0112, 0xF010, 0,, A
  sleep 50
  SendInput, {right}
}

SwitchWindows()
{
  wingetclass, class, A
  if (class == "ApplicationFrameWindow") {
    WinGetTitle, title, A
    to_check := title . " ahk_class ApplicationFrameWindow"
  }
  else
    to_check := "ahk_exe " . GetProcessName()

  MyGroupActivate(to_check)
  return
}

GetProcessName(id:="") {
  if (id == "")
    id := "A"
  else
    id := "ahk_id " . id

  WinGet name, ProcessName, %id%
  if (name == "ApplicationFrameHost.exe") {
    ;ControlGet hwnd, Hwnd,, Windows.UI.Core.CoreWindow, %id%
    ControlGet hwnd, Hwnd,, Windows.UI.Core.CoreWindow1, %id%
    if hwnd {
      WinGet name, ProcessName, ahk_id %hwnd%
    }
  }
  return name
}

activateFirstVisible(windowSelector)
{
  id := firstVisibleWindow(windowSelector)
  ; WinGet, State, MinMax, ahk_id %id%
  ; if (State = -1)
  ;     WinRestore, ahk_id %id%
  WinActivate, ahk_id %id%
}

firstVisibleWindow(windowSelector)
{
  WinGet, winList, List, %windowSelector%
  loop %winList%
  {
    item := winList%A_Index%
    WinGetTitle, title, ahk_id %item%
    ; if (Trim(title) != "") {
    WingetPos x, y, width, height, ahk_id %item%
    ; tip(width "-" height)
    if (Trim(title) != "" && (height > 20 || width > 20)) {
      return item
    }
  }
}

ActivateOrRun(to_activate:="", target:="", args:="", workingdir:="", RunAsAdmin:=false) 
{
  to_activate := Trim(to_activate)
  ; WinShow, %to_activate%
  ; if (to_activate && winexist(to_activate))
  if (to_activate && firstVisibleWindow(to_activate))
    MyGroupActivate(to_activate)
  else if (target != "")
  {
    ;showtip("not exist, try to start !")
    if (RunAsAdmin)
    {
      if (substr(target, 1, 1) == "\")
        target := substr(target, 2, strlen(target) - 1)
      Run, "%target%" %args%, %WorkingDir%
    }

    else
    {
      oldTarget := target
      target := WhereIs(target)
      if (target)
      {
        if (SubStr(target, -3) != ".lnk")
          ShellRun(target, args, workingdir)
        else {
          ; 检查 lnk 是否损坏
          FileGetShortcut, %target%, OutTarget
          ; if FileExist(OutTarget)
          ShellRun(target, args, workingdir)
        }

      } else {
        try 
        {
          if (workingdir && args) {
            run, %oldTarget% %args%, %workingdir%
          } 
          else if (workingdir) {
            run, %oldTarget%, %workingdir%
          } 
          else if (args) {
            run, %oldTarget% %args%
          }
          else {
            run, %oldTarget%
          }
        }
        catch e 
        {
          tip(e.message)
        } 
      }
    }

  }
}

WhereIs(FileName)
{
  ; https://autohotkey.com/board/topic/20807-fileexist-in-path-environment/

  ; Working Folder
  PathName := A_WorkingDir "\"
  IfExist, % PathName FileName, Return PathName FileName

  ; absolute path
  IfExist, % FileName, Return FileName

  ; Parsing DOS Path variable
  EnvGet, DosPath, Path
  Loop, Parse, DosPath, `;
  {
    IfEqual, A_LoopField,, Continue
    IfExist, % A_LoopField "\" FileName, Return A_LoopField "\" FileName
    }

  ; Looking up Registry
  RegRead, PathName, HKLM, SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\%FileName%
  IfExist, % PathName, Return PathName

}

GroupAdd(ByRef GroupName, p1:="", p2:="", p3:="", p4:="", p5:="")
{
  static g:= 1
  If (GroupName == "")
    GroupName:= "AutoName" g++
  GroupAdd %GroupName%, %p1%, %p2%, %p3%, %p4%, %p5%
}

HasVal(haystack, needle)
{
  if !(IsObject(haystack)) || (haystack.Length() = 0)
    return 0
  for index, value in haystack
    if (value = needle)
    return index
  return 0
}

MyGroupActivate(winFilter) 
{

  winFilter := Trim(winFilter)
  if (!winactive(winFilter))
  {
    activateFirstVisible(winFilter)
    return
  }

  ; group 是窗口组对象, 这个对象无法获取内部状态, 所以用 win_group_array_form 来储存他的状态
  global win_group
  global win_group_array_form
  global last_winFilter

  ; 判断是否进入了新的窗口组
  if (winFilter != last_winFilter)
  {
    last_winFilter := winFilter
    win_group_array_form := []
    win_group := "" ; 建立新的分组
  }

  ; 对比上一次的状态, 获取新的窗口, 然后把新窗口添加到 win_group_array_form 状态和 win_group
  curr_group := GetVisibleWindows(winFilter)
  loop % curr_group.Length()
  {
    val := curr_group[A_Index]
    if (!HasVal(win_group_array_form, val))
    {
      win_group_array_form.push(val)
      GroupAdd(win_group, "ahk_id " . val)
    }
  }

  ; showtip( "total:"  win_group_array_form.length())
  GroupActivate, %win_group%, R
}

WinVisible(id)
{
  ;WingetPos x, y, width, height, ahk_id %id%
  WinGetTitle, title, ahk_id %id%
  ;WinGet, state, MinMax, ahk_id %id%
  ;tooltip %x% %y% %width% %height%

  ;sizeTooSmall := width < 300 && height < 300 && state != -1 ; -1 is minimized
  empty := !trim(title)
  ;if (!sizeTooSmall && !empty)
  ;    tooltip %x% %y% %width% %height% "%title%" 

  return empty ? 0 : 1
  ;return  sizeTooSmall || empty  ? 0 : 1
}

GetVisibleWindows(winFilter)
{
  ids := []

  WinGet, id, list, %winFilter%,,Program Manager
  Loop, %id%
  {
    if (WinVisible(id%A_Index%))
      ids.push(id%A_Index%)
  }

  if (ids.length() == 0)
  {

    pos := Instr(winFilter, "ahk_exe") - StrLen(winFilter) + StrLen("ahk_exe")
    pname := Trim(Substr(winFilter, pos))
    WinGet, id, list, ahk_class ApplicationFrameWindow
    loop, %id%
    {
      get_name := GetProcessName(id%A_index%)
      if (get_name== pname)
        ids.push(id%A_index%)
    }

  }
  return ids
}

bindOrActivate(ByRef id)
{
  old := A_DetectHiddenWindows
  DetectHiddenWindows, 1
  if WinActive("ahk_id " id) {
    id := ""
    tip("取消绑定", -400)
  }
  else if WinExist("ahk_id " id) {
    WinActivate
  }
  else {
    tip("重新绑定 " A_ThisHotkey, -400)
    id := WinExist("A")
  }
  DetectHiddenWindows, %old%
}

IsBrowser(pname)
{
  if pname in chrome.exe,MicrosoftEdge.exe,firefox.exe,360se.exe,opera.exe,iexplore.exe,qqbrowser.exe,sogouexplorer.exe
    return true
}

SmartCloseWindow()
{
  if (winactive("ahk_class WorkerW ahk_exe explorer.exe"))
    return

  WinGetclass, class, A
  name := GetProcessName()
  if IsBrowser(name)
    send ^w
  else if WinActive("- Microsoft Visual Studio ahk_exe devenv.exe")
    send ^{f4}
  else
  {
    if (class == "ApplicationFrameWindow" || name == "explorer.exe")
      send !{f4}
    else
      PostMessage, 0x112, 0xF060,,, A
  }
}

; 滚动窗口
scrollOnce(direction, scrollCount :=1)
{
  if (direction == 1) {
    MouseClick, WheelUp, , , %scrollCount%
  }
  if (direction == 2) {
    MouseClick, WheelDown, , , %scrollCount%
  }
  if (direction == 3) {
    MouseClick, WheelLeft, , , %scrollCount%
  }
  if (direction == 4) {
    MouseClick, WheelRight, , , %scrollCount%
  }
}
scrollWheel(key, direction) {
  global scrollOnceLineCount, scrollDelay1, scrollDelay2 
  scrollOnce(direction, scrollOnceLineCount)
  keywait, %key%, %scrollDelay1%
  while (errorlevel != 0)
  {
    scrollOnce(direction)
    keywait, %key%, %scrollDelay2%
  }
}

ToggleTopMost()
{
  winexist("A")
  WinGet, style, ExStyle
  ; WinGetTitle, title, A
  if (style & 0x8) {
    tipText := " 取消置顶 "
    winset, alwaysontop, off
  }
  else {
    tipText := " 窗口置顶 " 
    winset, alwaysontop, on
  }
  showTip(tipText, 500)
}

; 窗口居中到当前显示器并且缩放
centerAndResizeCurrentWindowToCurrentMonitor(width, height)
{
  ; 在 mousemove 时需要 PER_MONITOR_AWARE (-3), 否则当两个显示器有不同的缩放比例时,  mousemove 会有诡异的漂移
  ; 在 winmove   时需要 UNAWARE (-1),           这样即使写死了窗口大小为 1200x800,  系统会帮你缩放到合适的大小
  DllCall("SetThreadDpiAwarenessContext", "ptr", -1, "ptr")

  ; WinExist win will set "A" to default window
  WinExist("A")
  SetWinDelay, 0
  WinGet, state, MinMax
  if state
    WinRestore
  WinGetPos, x, y, w, h
  ; Determine which monitor contains the center of the window.
  ms := wp_GetMonitorAt(x+w/2, y+h/2)
  ; Get source and destination work areas (excludes taskbar-reserved space.)
  SysGet, ms, MonitorWorkArea, %ms%
  msw := msRight - msLeft
  msh := msBottom - msTop
  ; win_w := msw * 0.67
  ; win_h := (msw * 10 / 16) * 0.7
  ; win_w := Min(win_w, win_h * 1.54)
  win_w := width
  win_h := height
  win_x := msLeft + (msw - win_w) / 2
  win_y := msTop + (msh - win_h) / 2
  winmove,,, %win_x%, %win_y%, %win_w%, %win_h%
  DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
}
