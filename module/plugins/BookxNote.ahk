; #If, WinActive("ahk_class Qt5150QWindowIcon") && NormalMode
#If, WinActive("ahk_class Qt5150QWindowIcon") && gValues.mode == "Normal"
  *i::
  global gValues
  gValues.mode := "Insert"
Return
*d::
  MsgBox, % A_LineFile
  send,{Blind}{PgDn}
Return
*e::
  send,{Blind}{Pgup}
Return
*h::
  scrollWheel("h",3)
Return
*j::
  scrollWheel("d",2)
Return
*k::
  scrollWheel("e",1)
Return
*l::
  scrollWheel("l",4)
Return

#If, WinActive("ahk_class Qt5150QWindowIcon") && gValues.mode == "Insert"
*Esc::
global gValues
gValues.mode := "Normal"
Return
*d::
  MsgBox, 12333
Return
; send,{Blind}
#If