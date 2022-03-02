; 系统操作相关的函数
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
    showTip("取消关机")
  }
}

slideToReboot()
{
  ; run, SlideToShutDown
  ; sleep, 1300
  ; MouseClick, Left, 100, 100
  ; sleep, 250
  shutdown, 2
}