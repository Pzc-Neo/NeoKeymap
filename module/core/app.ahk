trayMenuHandler(ItemName, ItemPos, MenuName)
{
  if (InStr(ItemName, "检查更新" )) {
    run, https://xianyukang.com/MyKeymap-Change-Log.html
  }
  if (InStr(ItemName, "视频教程" )) {
    run, https://space.bilibili.com/34674679
  }
  if (InStr(ItemName, "帮助文档" )) {
    run, https://xianyukang.com/MyKeymap.html
  }
  if (InStr(ItemName, "AutoHotKey文档" )) {
    run, https://wyagd001.github.io/zh-cn/docs/Tutorial.htm
  }
  if (InStr(ItemName, "查看窗口标识符" )) {
    run, module\tools\WindowSpy.ahk
  }
  if (InStr(ItemName, "打开设置" )) {
    openSettings()
  }
  if (InStr(ItemName, "重新载入" )) {
    ReloadProgram()
  }
  if (InStr(ItemName, "退出" )) {
    myExit()
  }
  if (InStr(ItemName, "暂停" )) {
    toggleSuspend()
  }
}

openSettings()
{
  ; run, module\ahk.exe module\openSettings.ahk
  MsgBox, 还没做，直接修改源码吧
}

myExit()
{
  Menu, Tray, NoIcon 
  thisPid := DllCall("GetCurrentProcessId")
  Process, Close, %thisPid%
}

toggleSuspend()
{
  Suspend, Toggle
  if (A_IsSuspended) {
    Menu, Tray, Check, 暂停
    tip(" 暂停 NeoKeymap ", -500)
  }
  else {
    Menu, Tray, UnCheck, 暂停
    tip(" 恢复 NeoKeymap ", -500)
  }
}

quit(ShowExitTip:=false)
{
  if (ShowExitTip)
  {
    ShowTip("Exit !")
    sleep 400
  }
  Menu, Tray, NoIcon 
  ; process, exist, KeyboardGeek.exe
  ; if (errorlevel > 0)
  ;     process, close, %errorlevel%
  ; process, close, ahk.exe
  myExit()
  exitapp
}

requireAdmin()
{
  if not A_IsAdmin
  {
    try {
      Run *RunAs "NeoKeymap.ahk" ; 需要 v1.0.92.01+
      myExit()
    }
    catch {
      tip("NeoKeymap 当前以普通权限运行 `n在一些高权限窗口中会完全失效 (比如任务管理器)", -3700)
    }
  }
}

ReloadProgram()
{
  Menu, Tray, NoIcon 
  tooltip, ` ` Reload !` ` 
  Reload
  ; run, MyKeymap.exe
  ; ExitApp
  ;run, "%exeFullPath%" Reload
  ;process, close, %pid%
  ;process, close, ahk.exe
}

getProcessList(pname)
{
  result := []
  query := % "SELECT Name,Handle FROM Win32_Process WHERE Name='" . pname . "'"
  for proc in ComObjGet("winmgmts:").ExecQuery(query)
    result.push(proc.Handle)
  return result
}

closeOldInstance()
{
  thisPid := DllCall("GetCurrentProcessId")
  for index,pid in getProcessList("AutoHotkey.exe")
  {
    if (pid != thisPid) {
      Process, Close, %pid%
      ;  tip("  Reload  ", -400)
    }
  }
}

