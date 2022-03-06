; 本文件存放的是 通用函数

#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

_ShowTip(text, size)
{
  SysGet, currMon, Monitor, % current_monitor_index()
  fontsize := (currMonRight - currMonLeft) / size

  Gui,G_Tip:destroy 
  Gui,G_Tip:New
  GUI, +Owner +LastFound

  global g_config
  Font_Colour := % g_config.style.fgColor ;0x2879ff
  Back_Colour := % g_config.style.bgColor ; 0x34495e
  GUI, Margin, %fontsize%, % fontsize / 2
  GUI, Color, % Back_Colour
  GUI, Font, c%Font_Colour% s%fontsize% w700, Microsoft YaHei UI
  GUI, Add, Text, center, %text%

  GUI, show, hide
  wingetpos, X, Y, Width, Height ; , ahk_id %H_Tip%
  Gui_X := (currMonRight + currMonLeft)/2.0 - Width/2.0
  Gui_Y := (currMonTop + currMonBottom) * 0.8
  GUI, show, NoActivate x%Gui_X% y%Gui_Y%, Tip

  GUI, +ToolWindow +Disabled -SysMenu -Caption +E0x20 +AlwaysOnTop 
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
