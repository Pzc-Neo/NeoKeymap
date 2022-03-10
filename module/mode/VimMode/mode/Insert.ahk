#If, VimMode.on && VimMode.mode == "Insert"
  *capslock::
  global VimMode
  VimMode.mode := "Normal"
Return
#If