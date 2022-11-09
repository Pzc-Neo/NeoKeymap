#If, VimMode.on && VimMode.mode == "Normal"
  *i::
  global VimMode
  VimMode.mode := "Insert"
Return
*a::
  global VimMode
  VimMode.mode := "Insert"
  send,{Blind}{Right}
Return

; leader
*Space::
  global VimMode
  VimMode.mode := "Leader"
Return

; 插入
+i::
  global VimMode
  VimMode.mode := "Insert"
  Send, {blind}{ShiftUp}{home}
Return
+a::
  global VimMode
  VimMode.mode := "Insert"
  Send, {blind}{ShiftUp}{End}
Return
o::
  global VimMode
  VimMode.mode := "Insert"
  Send, {blind}{End}{enter}
Return
+o::
  global VimMode
  VimMode.mode := "Insert"
  Send, {blind}{ShiftUp}{up}{End}{enter}
Return

; 选择
*v::
  global VimMode
  VimMode.mode := "Visual"
Return
*+v::
  global VimMode
  VimMode.mode := "Visual"
  Send, {Blind}{ShiftUp}{Home}+{End}
Return

; 移动
^*d::
  send,{Blind}{CtrlUp}}{Down 15}{CtrlDown} 
Return
^*e::
  send,{Blind}{CtrlUp}}{Up 15}{CtrlDown}
Return
g::
  if (A_PriorHotkey <> "g" or A_TimeSincePriorHotkey > 400)
  {
    ; Too much time between presses, so this isn't a double-press.
    KeyWait, g
    return
  }
  send {blind}^{Home}
return
+g::
  send, {Blind}{ShiftUp}}^{End}
return
*h::
  send,{Blind}{Left}
Return
*j::
  send,{Blind}{Down}
Return
*k::
  send,{Blind}{Up}
Return
*l::
  send,{Blind}{Right}
Return
*0::
  Send, {Blind}{Home}
Return
*$::
  Send, {Blind}{ShiftUp}{end}
Return
*w::
  Send, {blind}^{Right}
Return
*+w::
  Send, {blind}{ShiftUp}^{Left}{ShiftDown}
Return

; 粘贴
*p::
  send,{Blind}^v
Return

; 删除
*x::
  send,{Blind}{delete}
Return
*d::
  ; send,{Blind}{delete}
  global VimMode
  VimMode.mode := "Delect"
return
+c::
  Send, {Blind}+{end}
  send,{Blind}{delete}
  global VimMode
  VimMode.mode := "Normal"
Return

*u::
  send,{Blind}^z
Return
*+u::
  send,{Blind}{ShiftUp}^y{ShiftDown}
Return
^r::
  send,{Blind}^y
Return
*n::
  send,{enter}
Return

*f::
  global VimMode
  Input, key, L1 V
  if(key == "k"){
    MsgBox, % key . " key"
  }
  ; VimMode.mode := "FindInLine"
Return
#If
  ;   #If, VimMode.on && VimMode.mode == "FindInLine"
; *capslock::
; global VimMode
; VimMode.mode := "Normal"
; Return
; *d::
;   MsgBox, 12333
; Return
; #If
