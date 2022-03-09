; 数字模式
#if DigitMode

; *B::
; send, {blind}7
; return
; *Space::
; send, {blind}{f1}
; return
; 方案1
; *H::send {blind}0
; *J::send {blind}1
; *K::send {blind}2
; *L::send {blind}3
; *U::send {blind}4
; *I::send {blind}5
; *O::send {blind}6
; *N::send {blind}8
; *M::send {blind}9

; 方案2
; *L::send {blind}0
; *B::send {blind}1
; *N::send {blind}2
; *M::send {blind}3
; *H::send {blind}4
; *J::send {blind}5
; *K::send {blind}6
; *Y::send {blind}7
; *U::send {blind}8
; *I::send {blind}9

; 方案3
; u7 i8 o9
; j4 k5 l6
; m1 ,2 .3
; h0 ;,
*N::send {blind}0
*M::send {blind}1
*,::send {blind}2
*.::send {blind}3
*J::send {blind}4
*K::send {blind}5
*L::send {blind}6
*U::send {blind}7
*I::send {blind}8
*O::send {blind}9
*;::send {blind},
*Q::send {blind}{backspace}

*r::
  DigitMode := false
  FnMode := true
  keywait r
  FnMode := false
return
#If