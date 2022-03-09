;无视输入法中英文状态发送中英文字符串
;原理是, 发送英文时, 把它当做字符串来发送, 就像发送中文一样
;不通过模拟按键来发送,  而是发送它的Unicode编码
text(str)
{
  charList:=StrSplit(str)
  SetFormat, integer, hex
  for key,val in charList
    out.="{U+ " . ord(val) . "}"
  return out
}

ProcessExist(name)
{
  process, exist, %name%
  if (errorlevel > 0)
    return errorlevel
  else
    return false
}

ShowCommandBar()
{
  old := A_DetectHiddenWindows
  DetectHiddenWindows, 1
  PostMessage, 0x8003, 0, 0, , __KeyboardGeekInvisibleWindow
  DetectHiddenWindows, %old%
  ; winshow, __KeyboardGeekCommandBar
  ; winactivate, __KeyboardGeekCommandBar
}

ShowDimmer()
{
  global H_DImmer
  global DimmerInitiialized
  global Trans
  Trans := 55
  if (DimmerInitiialized == "")
  {
    SysGet,monitorcount,MonitorCount
    l:=0, t:=0, r:=0, b:=0
    Loop,%monitorcount%
    {
      SysGet,monitor,Monitor,%A_Index%
      If (monitorLeft<l)
        l:=monitorLeft
      If (monitorTop<t)
        t:=monitorTop
      If (monitorRight>r)
        r:=monitorRight
      If (monitorBottom>b)
        b:=monitorBottom
    }
    resolutionRight:=r+Abs(l)
    resolutionBottom:=b+Abs(t)

    Gui,G_Dimmer:New, +HwndH_DImmer +ToolWindow +Disabled -SysMenu -Caption +E0x20 +AlwaysOnTop 
    Gui,Margin,0,0
    Gui,Color,000000
    Gui,G_Dimmer:Show, X0 Y9999 W1 H1, _____
    Gui,G_Dimmer:Show, X%l% Y%t% W%resolutionRight% H%resolutionBottom%, _____

    gui, G_Dimmer:show, NoActivate
    WinSet,Transparent,%Trans%, ahk_id %H_DImmer%
    DimmerInitiialized := true
    settimer, WaitThenCloseDimmer, -400
  }
  else
  {

    IfWinActive, __KeyboardGeekCommandBar
      return
    Gui, G_Dimmer:Default, 
    Gui, +AlwaysOnTop 
    Gui, show, NoActivate
    ;Gui,G_Dimmer:New, +HwndH_DImmer +ToolWindow +Disabled -SysMenu -Caption +E0x20 
    WinSet,Transparent,%Trans%, ahk_id %H_DImmer%
    settimer, WaitThenCloseDimmer, -400
  }
}

WaitThenCloseDimmer() {
  settimer , WaitThenCloseDimmer, 150
  winget, pname, ProcessName, A
  if pname not in KeyboardGeek.exe,Listary.exe
  {
    Gui, G_Dimmer:Default
    gui, +LastFound
    While ( Trans > 0) ;这样做是增加淡出效果;
    { 		
      Trans -= 6
      WinSet, Transparent, %Trans% ;,  ahk_id %H_DImmer%
      Sleep, 4
    }
    Gui, hide
    settimer ,WaitThenCloseDimmer,off
  }
}

arrayContains(arr, target) 
{
  for index,value in arr 
    if (value == target)
    return true
  return false
}

dllMouseMove(offsetX, offsetY) {
  ; 需要在文件开头 CoordMode, Mouse, Screen
  ; MouseGetPos, xpos, ypos
  ; DllCall("SetCursorPos", "int", xpos + offsetX, "int", ypos + offsetY)    

  mousemove, %offsetX%, %offsetY%, 0, R
}

showMenu(window_id) {
  Prev_DetectHiddenWindows := A_DetectHiddenWindows
  DetectHiddenWindows On
  PostMessage, 0x5555,,,, ahk_id %window_id%
  DetectHiddenWindows %Prev_DetectHiddenWindows%
}

showMenu(window_id) {
  Prev_DetectHiddenWindows := A_DetectHiddenWindows
  DetectHiddenWindows On
  PostMessage, 0x5555,,,, ahk_id %window_id%
  DetectHiddenWindows %Prev_DetectHiddenWindows%
}

showXianyukangWindow() {
  Prev_DetectHiddenWindows := A_DetectHiddenWindows
  DetectHiddenWindows 1
  id := WinExist("ahk_class xianyukang_window")
  WinActivate, ahk_id %id%
  WinShow, ahk_id %id%
  DetectHiddenWindows %Prev_DetectHiddenWindows%
}

moveActiveWindow()
{
  wingetclass, class, A
  if (class == "ApplicationFrameWindow")
  {
    sendevent {lalt down}{space down}
    sleep 10
    sendevent {space up}{lalt up}
    sleep 10
    sendevent m{left}
  }
  else 
  {
    postmessage 0x0112, 0xF010, 0,, A
    send {left}
  }
}

enterJModeO()
{
  global JMode,JModeO
  JModeO := true
  JMode := false
  keywait o
  JModeO := false
  JMode := true
}

enterJModeL()
{
  global JMode,JModeL
  JModeL := true
  JMode := false
  keywait l
  JModeL := false
  JMode := true
}