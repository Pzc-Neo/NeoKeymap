#If, VimMode.on && VimMode.mode == "Visual"
  *capslock::
  global VimMode
  VimMode.mode := "Normal"
  ; send,{Blind}{Up}
  ; send,{Blind}{Down}
  send,{Blind}{Right}
Return

; leader
*Space::
  global VimMode
  VimMode.mode := "Leader"
Return

;因为习惯了按viw，所以加上这个
*i::return
*+v::
  Send, {Blind}{ShiftUp}{Home}+{End}
Return
*v::
Return

; 移动
*h::
  send,{Blind}+{Left}
Return
*j::
  send,{Blind}+{Down}
Return
*k::
  send,{Blind}+{Up}
Return
*l::
  send,{Blind}+{Right}
Return
*w::
  ; Send, {blind}+^{Right}
  Send, {blind}^{left}
  Send, {blind}+^{right}
Return
*+w::
  Send, {blind}+^{Left}
Return

*x::
  send,{Blind}^c
  send,{Blind}{BackSpace}
  global VimMode
  VimMode.mode := "Normal"
Return
*c::
  send,{Blind}^c
  send,{Blind}{BackSpace}
  global VimMode
  VimMode.mode := "Insert"
Return
*d::
  send,{Blind}^c
  send,{Blind}{delete}
  global VimMode
  VimMode.mode := "Normal"
Return
*0::
  Send, {Blind}+{Home}
  global VimMode
  VimMode.mode := "Normal"
Return
*$::
  Send, {Blind}+{end}
  global VimMode
  VimMode.mode := "Normal"
Return

*y::
  send,{Blind}^c
  global VimMode
  VimMode.mode := "Normal"
  send,{Blind}{Up}
  send,{Blind}{Down}
Return
*p::
  send,{Blind}^v
  global VimMode
  VimMode.mode := "Normal"
Return

; *i::
;   global VimMode
;   VimMode.mode := "Normal"
Return
#If