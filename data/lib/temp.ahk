; #SingleInstance, Force
; SendMode Input
; SetWorkingDir, %A_ScriptDir%

#if isUseTemp
  ,::
  send {Blind}@
  send %a_yyyy%-%a_mm%-%a_dd%
  send {Blind}d
return
#if