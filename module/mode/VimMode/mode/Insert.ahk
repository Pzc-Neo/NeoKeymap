#If, VimMode.on && VimMode.mode == "Insert"
  ~capslock::
  global VimMode
  VimMode.mode := "Normal"
  ; Send,{Blind} {Escape}
Return
#If