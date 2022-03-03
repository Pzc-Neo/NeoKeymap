;最钟爱代码之音量随心所欲
;=========================================================
~lbutton & enter:: ;鼠标放在任务栏，滚动滚轮实现音量的加减
exitapp 
~WheelUp:: 
  if (existclass("ahk_class Shell_TrayWnd")=1) 
    Send,{Volume_Up} 
Return 
~WheelDown:: 
  if (existclass("ahk_class Shell_TrayWnd")=1) 
    Send,{Volume_Down} 
Return 
~MButton:: 
  if (existclass("ahk_class Shell_TrayWnd")=1) 
    Send,{Volume_Mute} 
Return 

Existclass(class) 
{ 
  MouseGetPos,,,win 
  WinGet,winid,id,%class% 
  if win = %winid% 
    Return,1 
  Else 
    Return,0 
}

WinTransplus(w){

  WinGet, transparent, Transparent, ahk_id %w%
  if transparent < 255
    transparent := transparent+10
  else
    transparent =
  if transparent
    WinSet, Transparent, %transparent%, ahk_id %w%
  else
    WinSet, Transparent, off, ahk_id %w%
return
}
WinTransMinus(w){

  WinGet, transparent, Transparent, ahk_id %w%
  if transparent
    transparent := transparent-10
  else
    transparent := 240
  WinSet, Transparent, %transparent%, ahk_id %w%
return
}