#If, WinActive("ahk_class NeteaseYoudaoYNoteMainWnd") && gValues.mode == "Normal"
  *i::
  global gValues
  gValues.mode := "Insert"
Return
*d::
  send,{Blind}{Down 15}
  ; send,{Blind}{PgDn}
Return
*e::
  send,{Blind}{Up 15}
  ; send,{Blind}{Pgup}
Return
*h::
  send,{Blind}{Left}
  ; scrollWheel("h",3)
Return
*j::
  send,{Blind}{Down}
  ; scrollWheel("d",2)
Return
*k::
  send,{Blind}{Up}
  ; scrollWheel("e",1)
Return
*l::
  send,{Blind}{Right}
  ; scrollWheel("l",4)
Return

#If, WinActive("ahk_class NeteaseYoudaoYNoteMainWnd") && gValues.mode == "Insert"
  ; *Esc::
*capslock::
  global gValues
  gValues.mode := "Normal"
Return
*d::
  MsgBox, 12333
Return
; send,{Blind}
#If