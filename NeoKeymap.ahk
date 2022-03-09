#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 70
#NoTrayIcon
#WinActivateForce ; 解决「 winactivate 最小化的窗口时不会把窗口放到顶层(被其他窗口遮住) 」
#InstallKeybdHook ; 可能是 ahk 自动卸载 hook 导致的丢失 hook,  如果用这行指令, ahk 是否就不会卸载 hook 了呢?
#include data/config.ahk
global gConfig := readConfig()

#include, module/main.ahk
#Include, module/libs/ExecScript.ahk
; #Include, module\libs\customToolTip.ahk

StringCaseSense, On
SetWorkingDir %A_ScriptDir%
; 如果不是以管理员身份运行的话，就尝试用管理员身份重新运行
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
allHotkeys.Push("RButton")
allHotkeys.Push("*;")

  Menu, Tray, NoStandard
  Menu, Tray, Add, 视频教程, trayMenuHandler
  Menu, Tray, Add, 帮助文档, trayMenuHandler 
  Menu, Tray, Add, AutoHotKey文档, trayMenuHandler 
  Menu, Tray, Add, 检查更新, trayMenuHandler 
  Menu, Tray, Add, 查看窗口标识符, trayMenuHandler 
  Menu, Tray, Add, 打开设置, trayMenuHandler 
  Menu, Tray, Add, 重新载入, trayMenuHandler 
  Menu, Tray, Add, 暂停, trayMenuHandler
  Menu, Tray, Add, 退出, trayMenuHandler
  Menu, Tray, Add 

  Menu, Tray, Icon
  Menu, Tray, Icon, assets\logo.ico,, 1
  name := gConfig.name
  version := gConfig.version
  author := gConfig.author
  Menu, Tray, Tip, %name% %version% by %author% `n修改自 MyKeymap by 咸鱼阿康

  CoordMode, Mouse, Screen
  ; 多显示器不同缩放比例导致的问题,  https://www.autohotkey.com/boards/viewtopic.php?f=14&t=13810
  DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")

  global typoTip := new TypoTipWindow()

  semiHook := InputHook("C", "{Space}{BackSpace}{Esc}", "xk,ss,sk,sl,zk,dk,jt,gt,lx,sm,zh,gg,ver,xm,static,fs,fd,ff")
  semiHook.OnChar := Func("onTypoChar")
  semiHook.OnEnd := Func("onTypoEnd")
  capsHook := InputHook("C", "{Space}{BackSpace}{Esc}", "bb,cm,cs,ci,dd,dm,dp,dr,dv,dw,ee,et,ex,fb,fg,fi,fp,fr,fw,gg,io,ir,ld,md,mm,mw,no,rb,rex,sd,se,sl,ss,st,we,ws")
  capsHook.OnChar := Func("capsOnTypoChar")
  capsHook.OnEnd := Func("capsOnTypoEnd")

  #include data/customFunctions.ahk
  return

  /* 
    键位映射 
  */
  RAlt::LCtrl
  /::LShift

  /*
    软件操作快捷键 
  */
  ; 暂停/恢复 shift + alt + '
  !+'::
    Suspend, Permit
    toggleSuspend()
  return
  ; 重新加载 alt + '
  !'::
    Suspend, Toggle
    ReloadProgram()
  return
  ; 切换大小写 alt + capslock
  !capslock::toggleCapslock()

  /*
    按键模式 
  */
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

    #Include, module\mode\JMode\JMode.ahk
    #Include, module\mode\JMode\JModeO.ahk
    #Include, module\mode\JMode\JModeL.ahk
    #Include, module\mode\PunctuationMode\PunctuationMode.ahk
    #Include, module\mode\DigitMode\DigitMode.ahk
    #Include, module\mode\DigitMode\FnMode.ahk
    #Include, module\mode\CapslockMode\CapslockMode.ahk 
    #Include, module\mode\CapslockMode\FMode.ahk
    #Include, module\mode\CapslockMode\SpaceMode.ahk
    #Include, module\mode\MouseMode\RButtonMode.ahk
    #Include, module\mode\CommandAndAbbr\Command.ahk 
    #Include, module\mode\CommandAndAbbr\Abbr.ahk 

    #if DisableCapslockKey
      *capslock::return
  *capslock up::return

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

    ; 进入符号模式
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

      WM_USER := 0x0400
      SHOW_TYPO_WINDOW := WM_USER + 0x0001
      HIDE_TYPO_WINDOW := WM_USER + 0x0002

      _ShowTip(CapslockAbbrCommandChar,60)
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