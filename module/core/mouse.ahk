/* 
  【鼠标】函数：移动、点击等
*/

slowMoveMouse(key, direction_x, direction_y) {
  global slowMoveSingle, slowMoveRepeat, moveDelay1, moveDelay2 
  one_x := direction_x * slowMoveSingle
  one_y := direction_y * slowMoveSingle
  repeat_x := direction_x * slowMoveRepeat
  repeat_y := direction_y * slowMoveRepeat
  mousemove, %one_x% , %one_y%, 0, R
  keywait, %key%, %moveDelay1%
  while (errorlevel != 0)
  {
    mousemove, %repeat_x%, %repeat_y%, 0, R
    keywait, %key%, %moveDelay2%
  }
}

fastMoveMouse(key, direction_x, direction_y) {
  global fastMoveSingle, fastMoveRepeat, moveDelay1, moveDelay2, SLOWMODE
  SLOWMODE := true
  one_x := direction_x *fastMoveSingle 
  one_y := direction_y *fastMoveSingle 
  repeat_x := direction_x *fastMoveRepeat 
  repeat_y := direction_y *fastMoveRepeat 
  mousemove, %one_x% , %one_y%, 0, R
  keywait, %key%, %moveDelay1%
  while (errorlevel != 0)
  {
    mousemove, %repeat_x%, %repeat_y%, 0, R
    keywait, %key%, %moveDelay2%
  }
}

; 鼠标居中到当前窗口
centerMouse() 
{
  WingetPos x, y, width, height, A
  mousemove % x + width/2, y + height/2, 0
}

exitMouseMode() 
{
  global SLOWMODE
  SLOWMODE := false
  send {blind}{Lbutton up}
}

lbuttonDown() 
{
  send {Lbutton down}
}

leftClick() 
{
  global SLOWMODE
  send, {blind}{LButton}
  ; Click
  SLOWMODE := false
}

rightClick(tempDisableRButton := false) 
{
  global SLOWMODE
  if (!tempDisableRButton)
    send, {blind}{RButton}
  else {
    setHotkeyStatus("RButton", false)
    send, {blind}{RButton}
    sleep, 70
    setHotkeyStatus("RButton", true)
  }
  SLOWMODE := false
}