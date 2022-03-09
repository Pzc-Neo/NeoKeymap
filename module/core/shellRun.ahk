/*
  ShellRun by Lexikos
    requires: AutoHotkey_L
    license: http://creativecommons.org/publicdomain/zero/1.0/

  Credit for explaining this method goes to BrandonLive:
  http://brandonlive.com/2008/04/27/getting-the-shell-to-run-an-application-for-you-part-2-how/
 
  Shell.ShellExecute(File [, Arguments, Directory, Operation, Show])
  http://msdn.microsoft.com/en-us/library/windows/desktop/gg537745

  param: "Verb" (For example, pass "RunAs" to run as administrator)
  param: Suggestion to the application about how to show its window

  see the msdn link above for detail values

  useful links:
https://autohotkey.com/board/topic/72812-run-as-standard-limited-user/page-2#entry522235
https://msdn.microsoft.com/en-us/library/windows/desktop/gg537745
https://stackoverflow.com/questions/11169431/how-to-start-a-new-process-without-administrator-privileges-from-a-process-with
https://autohotkey.com/board/topic/149689-lexikos-running-unelevated-process-from-a-uac-elevated-process/#entry733408
https://autohotkey.com/boards/viewtopic.php?t=4334

*/

ShellRun(prms*)
{
  global shell

  try {

    try {
      if (shell) {
        ; tip("使用缓存了的 shell 对象")
        shell.ShellExecute(prms*)
        return
      }
    } catch {
      tip("refresh object")
    }

    shellWindows := ComObjCreate("Shell.Application").Windows
    VarSetCapacity(_hwnd, 4, 0)
    desktop := shellWindows.FindWindowSW(0, "", 8, ComObj(0x4003, &_hwnd), 1)

    ; Retrieve top-level browser object.
    if ptlb := ComObjQuery(desktop
        , "{4C96BE40-915C-11CF-99D3-00AA004AE837}" ; SID_STopLevelBrowser
    , "{000214E2-0000-0000-C000-000000000046}") ; IID_IShellBrowser
    {
      ; IShellBrowser.QueryActiveShellView -> IShellView
      if DllCall(NumGet(NumGet(ptlb+0)+15*A_PtrSize), "ptr", ptlb, "ptr*", psv:=0) = 0
      {
        ; Define IID_IDispatch.
        VarSetCapacity(IID_IDispatch, 16)
        NumPut(0x46000000000000C0, NumPut(0x20400, IID_IDispatch, "int64"), "int64")

        ; IShellView.GetItemObject -> IDispatch (object which implements IShellFolderViewDual)
        DllCall(NumGet(NumGet(psv+0)+15*A_PtrSize), "ptr", psv
        , "uint", 0, "ptr", &IID_IDispatch, "ptr*", pdisp:=0)

        ; Get Shell object.
        shell := ComObj(9,pdisp,1).Application

        ; IShellDispatch2.ShellExecute
        shell.ShellExecute(prms*)

        ; ObjRelease(psv)
      }
      ; ObjRelease(ptlb)
    }
  }
  catch {
    tip("run failed")
  }
}

closeToolTip() {
  ToolTip,
}

tip(message, time:=-1500) {
  tooltip, %message%
  settimer, closeToolTip, %time%
}

