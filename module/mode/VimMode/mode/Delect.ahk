#If, VimMode.on && VimMode.mode == "Delect"
  *capslock::
  global VimMode
  VimMode.mode := "Normal"
Return
*d::
  Send, {Blind}{Home}+{End}
  send,{Blind}^c
  send,{Blind}{delete}
  global VimMode
  VimMode.mode := "Normal"
Return
*0::
  Send, {Blind}+{Home}
  send,{Blind}^c
  send,{Blind}{delete}
  global VimMode
  VimMode.mode := "Normal"
Return
*$::
  Send, {Blind}+{end}
  send,{Blind}^c
  send,{Blind}{delete}
  global VimMode
  VimMode.mode := "Normal"
Return
*i::
Return
*w::
  Send, {blind}^{left}
  Send, {blind}+^{right}
  ; 在有道云笔记里面使用需要加上延时，不然指挥删第一个字符。
  Sleep, 100
  send,{Blind}^c
  send,{Blind}{delete}
  global VimMode
  VimMode.mode := "Normal"
Return

#if