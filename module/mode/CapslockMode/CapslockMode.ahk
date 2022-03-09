#if CapslockMode
  *C::
  send {blind}#{left}
return
*T::
  send {blind}#{right}
return
S::centerAndResizeCurrentWindowToCurrentMonitor(1200, 800)
A::centerAndResizeCurrentWindowToCurrentMonitor(800, 600)
*/::centerMouse()
*I::fastMoveMouse("I", 0, -1)
*J::fastMoveMouse("J", -1, 0)
*K::fastMoveMouse("K", 0, 1)
*L::fastMoveMouse("L", 1, 0)
*,::lbuttonDown()
*N::leftClick()
*.::moveCurrentWindow()
*M::rightClick()
*`;::scrollWheel(";", 4)
*H::scrollWheel("H", 3)
*O::scrollWheel("O", 2)
*U::scrollWheel("U", 1)
W::send !{tab}
D::send #+{right}
E::send ^!{tab}
Y::send {LControl down}{LWin down}{Left}{LWin up}{LControl up}
P::send {LControl down}{LWin down}{Right}{LWin up}{LControl up}
X::SmartCloseWindow()
R::SwitchWindows()
Q::toggleWinmaximize()
B::winMinimizeIgnoreDesktop()
*=:: ;窗口透明化增加或者减弱
  WinGet, ow, id, A
  WinTransplus(ow)
return
*-:: ;窗口透明化增加或者减弱
  WinGet, ow, id, A
  WinTransMinus(ow)
return
0::openSuperMenu()

f::
  FMode := true
  CapslockMode := false
  SLOWMODE := false
  keywait f
  FMode := false
return
space::
  CapslockSpaceMode := true
  CapslockMode := false
  SLOWMODE := false
  keywait space
  CapslockSpaceMode := false
return

WheelUp::send {blind}^#{left}
WheelDown::send {blind}^#{right}

#if SLOWMODE
  */::centerMouse()
*I::slowMoveMouse("I", 0, -1)
*J::slowMoveMouse("J", -1, 0)
*K::slowMoveMouse("K", 0, 1)
*L::slowMoveMouse("L", 1, 0)
*,::lbuttonDown()
*N::leftClick()
*.::moveCurrentWindow()
*M::rightClick(true)
*`;::scrollWheel(";", 4)
*H::scrollWheel("H", 3)
*O::scrollWheel("O", 2)
*U::scrollWheel("U", 1)

Esc::exitMouseMode()
*Space::exitMouseMode()

#If