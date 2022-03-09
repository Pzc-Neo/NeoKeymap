/* 
  操作窗口的函数
*/
; #SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; 最大化和还原 
toggleWinmaximize(){
  WinGet MX, MinMax, A
  If MX
    WinRestore A
  Else 
    WinMaximize A 
  return
}

; 使当前窗口变成可移动状态
; 就是鼠标左键在窗口标题那里按住不放的状态
moveCurrentWindow()
{
  PostMessage, 0x0112, 0xF010, 0,, A
  sleep 50
  SendInput, {right}
}