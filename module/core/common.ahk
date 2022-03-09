; 本文件存放的是 通用函数
current_monitor_index()
{
  SysGet, numberOfMonitors, MonitorCount
  WinGetPos, winX, winY, winWidth, winHeight, A
  winMidX := winX + winWidth / 2
  winMidY := winY + winHeight / 2
  Loop %numberOfMonitors%
  {
    SysGet, monArea, Monitor, %A_Index%
    ;MsgBox, %A_Index% %monAreaLeft% %winX%
    if (winMidX >= monAreaLeft && winMidX <= monAreaRight && winMidY <= monAreaBottom && winMidY >= monAreaTop)
      return A_Index
  }
}

; 获取autohotkey的安装路径(例：C:\Program Files\AutoHotkey)
getProcessPath() 
{
  old := A_DetectHiddenWindows
  DetectHiddenWindows, 1
  winget, exeFullPath, ProcessPath, ahk_id %A_ScriptHwnd%
  winget, pid, PID, ahk_id %A_ScriptHwnd%
  DetectHiddenWindows, %old%

  pos := InStr(exeFullPath, "\",, 0)
  parentPath := substr(exeFullPath, 1, pos)
  return parentPath
}

_ShowTip(text, size)
{
  SysGet, currMon, Monitor, % current_monitor_index()
  fontsize := (currMonRight - currMonLeft) / size

  Gui,G_Tip:destroy 
  Gui,G_Tip:New
  GUI, +Owner +LastFound

  global gConfig
  Font_Colour := % gConfig.style.fgColor ;0x2879ff
  Back_Colour := % gConfig.style.bgColor ; 0x34495e
  GUI, Margin, %fontsize%, % fontsize / 2
  GUI, Color, % Back_Colour
  GUI, Font, c%Font_Colour% s%fontsize% w700, Microsoft YaHei UI
  GUI, Add, Text, center, %text%

  GUI, show, hide
  wingetpos, X, Y, Width, Height ; , ahk_id %H_Tip%
  Gui_X := (currMonRight + currMonLeft)/2.0 - Width/2.0
  Gui_Y := (currMonTop + currMonBottom) * 0.8
  GUI, show, NoActivate x%Gui_X% y%Gui_Y%, Tip

  GUI, +ToolWindow +Disabled -SysMenu -Caption +E0x20 +AlwaysOnTop +border
  GUI, show, Autosize NoActivate

}

ShowTip(text, time:=2000, size:=60) 
{
  _ShowTip(text, size)
  settimer, CancelTip, -%time%
}

CancelTip()
{
  gui,G_Tip:destroy
}
