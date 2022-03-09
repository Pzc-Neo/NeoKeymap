#if JMode
  ; 把原来的k改成o，因为k会影响双拼。
o::
  global JMode,JModeO
  JModeO := true
  JMode := false
  keywait o
  JModeO := false
  JMode := true
return

l::
  global JMode,JModeL
  JModeL := true
  JMode := false
  keywait l
  JModeL := false
  JMode := true
Return

*Space::
  send {blind}{enter}
return
; 拼音及双拼修复 - start
*I::
  send, {blind}ji
return
*k::
  send, {blind}jk
return
*p::
  send, {blind}jp
return
*b::
  send, {blind}jb
return
*t::
  send, {blind}jt
return
; 拼音及双拼修复 - end
*.::
  send, {blind}{insert}
return
*W::send {blind}+{tab}
*Z::send {blind}{appskey}
*C::send {blind}{backspace}
*V::send {blind}{delete}
*D::send {blind}{down}
*G::send {blind}{end}
*X::send {blind}{esc}
*A::send {blind}{home}
*S::send {blind}{left}
; *T::send {blind}{pgdn}
; *Q::send {blind}{pgup}
*F::send {blind}{right}
*R::send {blind}{tab}
*E::send {blind}{up}
#If