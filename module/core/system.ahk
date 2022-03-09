; 系统操作相关的函数，关机、重启、启动/激活软件等
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; 滑动关机
slideToShutdown()
{
  MsgBox, 4,, 确定要关机吗?
  IfMsgBox Yes
  {
    run, SlideToShutDown
    sleep, 1300
    MouseClick, Left, 100, 100
  }
  else
  {
    showTip("取消关机",1500)
  }
}

slideToReboot()
{
  MsgBox, 4,, 确定要重启吗?
  IfMsgBox Yes
  {
    shutdown, 2
    ; run, SlideToShutDown
    ; sleep, 1300
    ; MouseClick, Left, 100, 100
  }
  else
  {
    showTip("取消重启",1500)
  }
  ; run, SlideToShutDown
  ; sleep, 1300
  ; MouseClick, Left, 100, 100
  ; sleep, 250
} 

; 显示/隐藏任务栏
toggleAutoHideTaskBar()
{
  VarSetCapacity(APPBARDATA, A_PtrSize=4 ? 36:48)
  NumPut(DllCall("Shell32\SHAppBarMessage", "UInt", 4 ; ABM_GETSTATE
    , "Ptr", &APPBARDATA
  , "Int")
? 2:1, APPBARDATA, A_PtrSize=4 ? 32:40) ; 2 - ABS_ALWAYSONTOP, 1 - ABS_AUTOHIDE
, DllCall("Shell32\SHAppBarMessage", "UInt", 10 ; ABM_SETSTATE
, "Ptr", &APPBARDATA)
}

; 重启文件浏览器
restartExplorer()
{
  ; run, tools\Rexplorer_x64.exe
  Process,close,explorer.exe
  sleep, 5000 ;This sleep 5000 is to let you see what actually happens. Decrease it later
  run, explorer.exe
  return
}