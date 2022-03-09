#if RButtonMode
  *Z::
  send {blind}#v
return
*Space::
  send {blind}{enter}
return
*G::
  send, {blind}{end}
return
*X::
  send, {blind}{esc}
return
*A::
  send, {blind}{home}
return
*C::send {blind}{backspace}
*V::send {blind}{delete}
*D::send {blind}{down}
*S::send {blind}{left}
*F::send {blind}{right}
*E::send {blind}{up}

LButton::
  ; if WinActive("ahk_class MultitaskingViewFrame")
  if ( A_PriorHotkey == "~LButton" || A_PriorHotkey == "LButton")
    send #{tab}
  else
    send ^!{tab}
return
WheelUp::send ^+{tab}
WheelDown::send ^{tab}

#if