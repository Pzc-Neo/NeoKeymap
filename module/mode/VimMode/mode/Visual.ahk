#If, VimMode.on && VimMode.mode == "Visual"
  *capslock::
  global VimMode
  VimMode.mode := "Normal"
  send,{Blind}{Up}
  send,{Blind}{Down}
Return
*+v::
  Send, {Blind}{ShiftUp}}{Home}+{End}
Return

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
;因为习惯了按viw
*i::
return
*w::
  ; Send, {blind}+^{Right}
  Send, {blind}^{left}
  Send, {blind}+^{right}
Return
*+w::
  Send, {blind}+^{Left}
Return

*x::
  send,{Blind}{BackSpace}
  global VimMode
  VimMode.mode := "Normal"
Return
*d::
  send,{Blind}{delete}
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