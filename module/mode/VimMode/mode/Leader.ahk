#If, VimMode.on && VimMode.mode == "Leader"
  ~capslock::
  global VimMode
  VimMode.mode := "Normal"
Return
*s::
  global VimMode
  VimMode.mode := "Normal"
  Send, {Blind}^s
Return
*q::
  global VimMode
  VimMode.mode := "Normal"
  Send, {Blind}^w
Return

; 移动
*d::
  global VimMode
  VimMode.mode := "Normal"
  send,{Blind}{CtrlUp}}{Down 15} 
Return
*e::
  global VimMode
  VimMode.mode := "Normal"
  send,{Blind}{CtrlUp}}{Up 15}
Return

#If