﻿#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 70
#NoTrayIcon
#WinActivateForce ; 解决「 winactivate 最小化的窗口时不会把窗口放到顶层(被其他窗口遮住) 」
#InstallKeybdHook ; 可能是 ahk 自动卸载 hook 导致的丢失 hook,  如果用这行指令, ahk 是否就不会卸载 hook 了呢?
#Include, module/common.ahk
#Include, module/system.ahk
#include module/functions.ahk

StringCaseSense, On
SetWorkingDir %A_ScriptDir%
requireAdmin()
closeOldInstance()

SetBatchLines -1
ListLines Off
process, Priority,, H
; 使用 sendinput 时,  通过 alt+3+j 输入 alt+1 时,  会发送 ctrl+alt
SendMode Input
; SetKeyDelay, 0
; SetMouseDelay, 0

SetMouseDelay, 0 ; 发送完一个鼠标后不会 sleep
SetDefaultMouseSpeed, 0
coordmode, mouse, screen
settitlematchmode, 2

; win10 任务切换、任务视图
GroupAdd, TASK_SWITCH_GROUP, ahk_class MultitaskingViewFrame
; GroupAdd, TASK_SWITCH_GROUP, ahk_class Windows.UI.Core.CoreWindow
; win11 任务切换、任务视图
GroupAdd, TASK_SWITCH_GROUP, ahk_class XamlExplorerHostIslandWindow

scrollOnceLineCount := 1
scrollDelay1 = T0.2
scrollDelay2 = T0.03

fastMoveSingle := 110
fastMoveRepeat := 70
slowMoveSingle := 10
slowMoveRepeat := 13
moveDelay1 = T0.13
moveDelay2 = T0.01

SemicolonAbbrTip := true
; time_enter_repeat = T0.2
; delay_before_repeat = T0.01
; fast_one := 110     
; fast_repeat := 70
; slow_one :=  10     
; slow_repeat := 13

allHotkeys := []
allHotkeys.Push("*3")
allHotkeys.Push("*j")
allHotkeys.Push("*capslock")
allHotkeys.Push("*;")
  allHotkeys.Push("RButton")

  Menu, Tray, NoStandard
  ; Menu, Tray, Add, 打开设置, trayMenuHandler 
  Menu, Tray, Add, 视频教程, trayMenuHandler
  Menu, Tray, Add, 帮助文档, trayMenuHandler 
  Menu, Tray, Add, 检查更新, trayMenuHandler 
  Menu, Tray, Add, 查看窗口标识符, trayMenuHandler 
  Menu, Tray, Add, 重新载入, trayMenuHandler 
  Menu, Tray, Add, 暂停, trayMenuHandler
  Menu, Tray, Add, 退出, trayMenuHandler
  Menu, Tray, Add 

  Menu, Tray, Icon
  Menu, Tray, Icon, assets\logo.ico,, 1
  Menu, Tray, Tip, NeoKeymap 1.0 by Pzc_Neo
  ; processPath := getProcessPath()
  ; SetWorkingDir, %processPath%

  CoordMode, Mouse, Screen
  ; 多显示器不同缩放比例导致的问题,  https://www.autohotkey.com/boards/viewtopic.php?f=14&t=13810
  DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")

  global typoTip := new TypoTipWindow()

  semiHook := InputHook("C", "{Space}{BackSpace}{Esc}", "xk,ss,sk,sl,zk,dk,jt,gt,lx,sm,zh,gg,ver,xm,static,fs,fd,ff")
  semiHook.OnChar := Func("onTypoChar")
  semiHook.OnEnd := Func("onTypoEnd")
  capsHook := InputHook("C", "{Space}{BackSpace}{Esc}", "ss,sl,ex,rb,fp,fb,fg,dd,dp,dv,dr,se,no,sd,ld,we,st,dw,bb,gg,fr,fi,ee,dm,rex,fw,mm,md,cs,cm,ir,io,mw,ws")
  capsHook.OnChar := Func("capsOnTypoChar")
  capsHook.OnEnd := Func("capsOnTypoEnd")

  #include data/customFunctions.ahk
  return

  RAlt::LCtrl

  !+'::
    Suspend, Permit
    toggleSuspend()
  return
  !'::
    Suspend, Toggle
    ReloadProgram()
  return

  !capslock::toggleCapslock()

  *capslock::
    thisHotkey := A_ThisHotkey
    disableOtherHotkey(thisHotkey)
    CapslockMode := true
    keywait capslock
    CapslockMode := false
    if (A_ThisHotkey == "*capslock" && A_PriorKey == "CapsLock" && A_TimeSinceThisHotkey < 450) {
      ; 取消单按capslock键的指令功能，改为发送escape键
      ; enterCapslockAbbr(capsHook)
      send {blind}{Escape}
    }
    enableOtherHotkey(thisHotkey)
  return
  ; 右shift进入指令模式   
  *RShift::
    enterCapslockAbbr(capsHook)

  *j::
    thisHotkey := A_ThisHotkey
    disableOtherHotkey(thisHotkey)
    JMode := true
    DisableCapslockKey := true
    keywait j
    JMode := false
    DisableCapslockKey := false
    if (A_PriorKey == "j" && A_TimeSinceThisHotkey < 350)
      send {blind}j
    enableOtherHotkey(thisHotkey)
  return

  *`;::
  thisHotkey := A_ThisHotkey
  disableOtherHotkey(thisHotkey)
  PunctuationMode := true
  keywait `; 
  PunctuationMode := false
  if (A_PriorKey == ";" && A_TimeSinceThisHotkey < 350)
      enterSemicolonAbbr(semiHook)
    enableOtherHotkey(thisHotkey)
  return

  *3::
    start_tick := A_TickCount
    thisHotkey := A_ThisHotkey
    disableOtherHotkey(thisHotkey)
    DigitMode := true
    keywait 3 
    DigitMode := false
    if (A_PriorKey == "3" && (A_TickCount - start_tick < 250))
      send {blind}3 
    enableOtherHotkey(thisHotkey)
  return

  RButton::
    enterRButtonMode()
    {
      global RButtonMode
      thisHotkey := A_ThisHotkey
      RButtonMode := true
      timeOut = T0.01
      movedMouse := false
      MouseGetPos, initialX, initialY

      ; 当按下右键时跑一个循环,  移动鼠标 / 弹起鼠标右键才能跳出这个循环
      keywait, RButton, %timeOut%
      while (errorlevel != 0)
      {
        MouseGetPos, x, y
        if (Abs(x - initialX) > 20 || Abs(y - initialY) > 20) {
          movedMouse := true
          break
        }
        keywait, RButton, %timeOut%
      }

      RButtonMode := false
      triggerOtherHotkey := thisHotkey != A_ThisHotkey
      Hotkey, %thisHotkey%, Off

      ; 如果移动了鼠标,  那么按下鼠标右键,  以兼容其他软件的鼠标手势,  需要等待 RButton 弹起后才能重新启用热键
      if (!triggerOtherHotkey && movedMouse) {
        SendInput, {Blind}{RButton down}
        keywait, RButton
      } 
      else if (!triggerOtherHotkey) {
        SendInput, {Blind}{RButton}
      }
      ; 这里睡眠很重要, 否则会触发无限循环的 bug, 因为发送 RButton 触发 RButton 热键
      sleep, 70
      Hotkey, %thisHotkey%, On
      return

    }

    #if JModeK
      k::return
  *V::
    send, {blind}+{del}
  return
  *D::
    send, {blind}+{down}
  return
  *G::
    send, {blind}+{end}
  return
  *X::
    send, {blind}+{esc}
  return
  *A::
    send, {blind}+{home}
  return
  *S::
    send, {blind}+{left}
  return
  *F::
    send, {blind}+{right}
  return
  *E::
    send, {blind}+{up}
  return
  *W::
    send, {blind}^+{left}
  return
  *R::
    send, {blind}^+{right}
  return
  *C::
    send, {blind}{bs}
  return
  *T::
    send, {blind}{home}+{end}
  return

  #if JModeL
  l::return
*W::
  send, {blind}^+{tab}
return
*C::
  send, {blind}^{bs}
return
*G::
  send, {blind}^{end}
return
*A::
  send, {blind}^{home}
return
*S::
  send, {blind}^{left}
return
*F::
  send, {blind}^{right}
return
*R::
  send, {blind}^{tab}
return

#if JMode
  ; 把原来的k改成o，因为k会影响双拼。
o::enterJModeK()
l::enterJModeL()

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
*T::send {blind}{pgdn}
*Q::send {blind}{pgup}
*F::send {blind}{right}
*R::send {blind}{tab}
*E::send {blind}{up}

; 分号模式
#if PunctuationMode
*A::
send {blind}*
return
*I::
send {blind}:
return
*B::
  send, {blind}`%
return
*J::
  send, {blind}`;
return
*K::
  send, {blind}``
return
*H::
  send, {blind}{+}
return
*O::
  send, {blind}{end};
return
*Space::
  send, {blind}{enter}
return
*U::send {blind}$
*R::send {blind}&
*Q::send {blind}@
*M::send {blind}-
*C::send {blind}.
*N::send {blind}/
*S::send {blind}(
  *D::send {blind}=
*F::send {blind})
*Y::send {blind}@
*Z::send {blind}\
*X::send {blind}_
*G::send {blind}{!}
*W::send {blind}{#}
*E::send {blind}{^}
*V::send {blind}|
*T::send {blind}~

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
; n1 m2 ,3
; h0 ;,
*H::send {blind}0
*N::send {blind}1
*M::send {blind}2
*,::send {blind}3
*J::send {blind}4
*K::send {blind}5
*L::send {blind}6
*U::send {blind}7
*I::send {blind}8
*O::send {blind}9
*;::send {blind},

*r::
  DigitMode := false
  FnMode := true
  keywait r
  FnMode := false
return

#if FnMode
*r::return

*.::
  send, {blind}{f12}
return
*B::
  send, {blind}{f7}
return
*H::send {blind}{f10}
*,::send {blind}{f11}
*J::send {blind}{f1}
*K::send {blind}{f2}
*L::send {blind}{f3}
*U::send {blind}{f4}
*I::send {blind}{f5}
*O::send {blind}{f6}
*N::send {blind}{f8}
*M::send {blind}{f9}

#if CapslockMode

*C::
  send {blind}#{left}
return
*T::
  send {blind}#{right}
return
S::center_window_to_current_monitor(1200, 800)
A::center_window_to_current_monitor(1370, 930)
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
Q::winmaximize, A
B::winMinimizeIgnoreDesktop()

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

; capslock 的 f mode
#if FMode
f::return

,::
  global CapslockF__comma
  bindOrActivate(CapslockF__comma)
return
M::
  global CapslockF__M
  bindOrActivate(CapslockF__M)
return
N::
  global CapslockF__N
  bindOrActivate(CapslockF__N)
return
K::
  path = %A_ProgramFiles%\DAUM\PotPlayer\PotPlayerMini64.exe
  workingDir = 
  ActivateOrRun("ahk_class PotPlayer64", path, "", workingDir)
return
Q::
  path = %A_ProgramFiles%\Everything\Everything.exe
  ActivateOrRun("ahk_class EVERYTHING", path)
return
U::
  path = %A_Programs%\JetBrains Toolbox\DataGrip.lnk
  ActivateOrRun("ahk_exe datagrip64.exe", path)
return
J::
  path = %A_Programs%\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk
  ActivateOrRun("ahk_exe idea64.exe", path, "", "")
return
S::
  path = %A_Programs%\Visual Studio Code\Visual Studio Code.lnk
  ActivateOrRun("ahk_exe Code.exe", path)
return
W::
  ; path = %A_ProgramsCommon%\Google Chrome.lnk
  path = C:\Users\Administrator.USER-20181115EQ\AppData\Local\360Chrome\Chrome\Application\360chrome.exe
  ActivateOrRun("ahk_exe 360chrome.exe", path)
return
D::
  path = %A_ProgramsCommon%\Microsoft Edge.lnk
  ActivateOrRun("ahk_exe msedge.exe", path)
return
H::
  path = %A_ProgramsCommon%\Visual Studio 2019.lnk
  ActivateOrRun("- Microsoft Visual Studio", path)
return
E::
  path = C:\Program Files (x86)\Yinxiang Biji\印象笔记\Evernote.exe
  ActivateOrRun("ahk_class YXMainFrame", path)
return
I::
  path = C:\Program Files\Typora\Typora.exe
  ActivateOrRun("ahk_exe Typora.exe", path)
return
L::
  path = C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk
  workingDir = 
  ActivateOrRun("ahk_exe EXCEL.EXE", path, "", workingDir)
return
P::
  path = C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk
  ActivateOrRun("ahk_exe POWERPNT.EXE", path, "", "")
return
Z::
  path = D:\
  ActivateOrRun("ahk_class CabinetWClass ahk_exe Explorer.EXE", path)
return
R::
  path = D:\install\Foxit Reader\FoxitReader.exe
  ActivateOrRun("ahk_exe FoxitReader.exe", path)
return
O::
  path = shortcuts\OneNote for Windows 10.lnk
    ActivateOrRun("OneNote for Windows 10", path)
return
A::
  ; path = shortcuts\Windows Terminal Preview.lnk
  path = cmd.exe
  ActivateOrRun("ahk_exe cmd.exe", path)
return

#if CapslockSpaceMode
space::return

#if DisableCapslockKey
*capslock::return
*capslock up::return

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

#IfWinActive, ahk_group TASK_SWITCH_GROUP
  ; *W::send, {blind}+{Tab}
  ; *R::send, {blind}{Tab}
  *D::send, {blind}{down}
  *E::send, {blind}{up}
  *S::send, {blind}{left}
  *F::send, {blind}{right}
  *X::send, {blind}{del}
  *Space::send, {blind}{enter}
  #If

  execSemicolonAbbr(typo) {
    switch typo 
    {
    case "ver":

      send, {blind}#r
      sleep 700
      send, {blind}winver{enter}
    return
  case "zh":

    send, {blind}{text} site:zhihu.com
  return
case "ss":

  send, {blind}{text}""
  send, {blind}{left}
return
case "xk":

  send, {blind}{text}()
  send, {blind}{left 1}
return
case "gg":

  send, {blind}{text}git add -A`; git commit -a -m ""`; git push origin (git branch --show-current)`;
  send, {blind}{left 47}
return
case "static":

  send, {blind}{text}https://static.xianyukang.com/
return
case "dk":

  send, {blind}{text}{}
  send, {blind}{left}
return
case "xm":

  send, {blind}{text}❖` ` 
return
case "jt":

  send, {blind}{text}➤` ` 
return
case "fs":

  send, {blind}{text}、
return
case "ff":

  send, {blind}{text}。
return
case "sm":

  send, {blind}{text}《》
  send, {blind}{left}
return
case "sk":

  send, {blind}{text}「 」
  send, {blind}{left 2}
return
case "sl":

  send, {blind}{text}【】
  send, {blind}{left 1}
return
case "fd":

  send, {blind}{text}，
return
case "gt":

  send, {blind}{text}🐶
return
case "lx":

  send, {blind}{text}💚
return
case "zk":
  send {blind}[]{left}
default: 
return false
}
return true
}

; 执行capslock指令
execCapslockAbbr(typo) {
  switch typo 
  {
  case "ir":

    path = %A_Programs%\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk
    ActivateOrRun("room-api ahk_exe idea64.exe", path, "D:\work\room-api", "")
  return
case "io":

  path = %A_Programs%\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk
  ActivateOrRun("room-order-api ahk_exe idea64.exe", path, "D:\work\room-order-api", "")
return
case "cs":

  path = %A_Programs%\Visual Studio Code\Visual Studio Code.lnk
  ActivateOrRun("my_site - Visual Studio Code", path, "D:\project\my_site", "")
return
case "cm":

  path = %A_Programs%\Visual Studio Code\Visual Studio Code.lnk
  ActivateOrRun("MyKeymap - Visual Studio Code", path, "D:\MyFiles\MyKeymap", "")
return
case "fw":

  path = %A_ProgramsCommon%\Google Chrome.lnk
  ActivateOrRun("", path, "", "")
return
case "bb":

  path = C:\Program Files\Google\Chrome\Application\chrome.exe
  ActivateOrRun("Bing 词典", path, "--app=https://cn.bing.com/dict/search?q=nice", "")
return
case "gg":

  path = C:\Program Files\Google\Chrome\Application\chrome.exe
  ActivateOrRun("Google 翻译", path, "--app=https://translate.google.cn/?op=translate&sl=auto&tl=zh-CN&text=nice", "")
return
case "mm":

  path = D:\notes\MyKeymap-Roadmap.md
  ActivateOrRun("MyKeymap-Roadmap.md - Typora", path, "", "")
return
case "mw":

  path = D:\notes\working.md
  ActivateOrRun("working.md - Typora", path, "", "")
return
case "md":

  path = D:\project\my_site\docs\MyKeymap.md
  ActivateOrRun("MyKeymap.md - Typora", path, "", "")
return
case "no":

  path = notepad.exe
  ActivateOrRun("记事本", path, "", "")
return
case "st":

  path = shortcuts\Store.lnk
  ActivateOrRun("Microsoft Store", path, "", "")
return
case "we":

  path = shortcuts\网易云音乐.lnk
  ActivateOrRun("网易云音乐", path)
return
case "sl":
  DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
  ; case "se":
  ;    openSettings()
case "ex":
  quit(false)
case "rex":
  restartExplorer()
case "dm":
  run, %A_WorkingDir%
case "ld":
  run, module\changeBrightness.ahk
  ;  run, module\ahk.exe module\changeBrightness.ahk
case "sd":
  run, module\soundControl.ahk
  ;  run, module\ahk.exe module\soundControl.ahk
case "ws":
  run, module\WindowSpy.ahk
  ;  run, module\ahk.exe module\soundControl.ahk
case "dd":
  run, shell:downloads
case "dp":
  run, shell:my pictures
case "dv":
  run, shell:My Video
case "dw":
  run, shell:Personal
case "dr":
  run, shell:RecycleBinFolder
case "fg":
  setColor("#080")
case "fb":
  setColor("#2E66FF")
case "fp":
  setColor("#b309bb")
case "fr":
  setColor("#D05")
case "fi":
  setColor("#FF00FF")
case "rb":
  slideToReboot()
case "ss":
  slideToShutdown()
case "ee":
  ToggleTopMost()
default: 
return false
}
return true
}

enterSemicolonAbbr(ih) 
{
  global DisableCapslockKey
  DisableCapslockKey := true

  typoTip.show(" ") 
  ih.Start()
  ih.Wait()
  ih.Stop()
  typoTip.hide()
  DisableCapslockKey := false

  if (ih.Match)
    execSemicolonAbbr(ih.Match)
}

onTypoChar(ih, char) {
  typoTip.show(ih.Input)
}

onTypoEnd(ih) {
  ; typoTip.show(ih.Input)
}
capsOnTypoChar(ih, char) {
  postCharToTipWidnow(char)
}

capsOnTypoEnd(ih) {
  ; typoTip.show(ih.Input)
}

; 记录当前输入的指令
global CapslockAbbrCommandChar = ""
enterCapslockAbbr(ih) 
{
  ; ShowTip("进入指令模式",500)

  _ShowTip("",60)
  WM_USER := 0x0400
  SHOW_TYPO_WINDOW := WM_USER + 0x0001
  HIDE_TYPO_WINDOW := WM_USER + 0x0002

  ; postMessageToTipWidnow(SHOW_TYPO_WINDOW)
  ; result := ""

  ih.Start()
  endReason := ih.Wait()
  ih.Stop()
  if InStr(endReason, "EndKey") {
    CapslockAbbrCommandChar := ""
    ; SetTimer, CancelTip, 50
    CancelTip()
  }
  if InStr(endReason, "Match") {
    lastChar := SubStr(ih.Match, ih.Match.Length-1)
    postCharToTipWidnow(lastChar)
    SetTimer, delayedHideTipWindow, -50

    CapslockAbbrCommandChar := ""
    ; SetTimer, CancelTip, 300
    CancelTip()
    ; } else {
    ;   postMessageToTipWidnow(HIDE_TYPO_WINDOW)
  }
  if (ih.Match)
    execCapslockAbbr(ih.Match)
}

delayedHideTipWindow()
{
  HIDE_TYPO_WINDOW := 0x0400 + 0x0002
  postMessageToTipWidnow(HIDE_TYPO_WINDOW)
}

