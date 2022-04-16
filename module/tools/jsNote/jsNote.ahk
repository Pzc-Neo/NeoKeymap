; 来源：https://www.autoahk.com/archives/39526 
; 一个用来简单记事的工具
; 运行后默认显示/隐藏窗口热键 Ctrl F12, 可以在set.ini里修改
; 可以调整每条内容的顺序
; 目前已知的，在连续频繁调顺序的过程中有几率内容错乱【我暂时无解】
; 运行的时候自动创建一个Set.ini文件
; 新建内容的时候会新建js.ini文件
loadjsb:
  Menu, Tray, NoStandard
  Menu, Tray, DeleteAll
  Menu, Tray, Add, 记事本, ShowOrHide
  Menu, Tray, Add, 重启, 重启
  Menu, Tray, Add, 退出, 退出
  Menu, Tray, Default, 记事本
  Menu, Tray, Tip, 默认显示快捷键Ctrl F12 `n Set.ini里可以修改 `n 右键双击条目可以对下面扩展的Edit框编辑
  Menu, Tray, Click, 2
  Gui, +HwndNoteBQ +AlwaysOnTop +LastFound
  Gui, Font, s16
  Gui, Add, Edit, h30 w480 Section vNewjs
  Gui, Add, Button, h30 xs ys+35 g新建, 添加
  Gui, Add, Button, h30 x+5 g插入, 插入
  Gui, Add, Button, h30 x+5 g删除, 删除
  Gui, Add, Text, h30 x+5 yp+4, |
  Gui, Add, Button, h30 x+5 yp-4 g向上, 向上
  Gui, Add, Button, h30 x+5 g向下, 向下
  Gui, Add, Edit, h30 w64 x+5
  Gui, Add, UpDown, h30 x+5 v目标行号 Range1-300
  Gui, Add, Button, h30 x+5 g移动, 移动
  Gui, Add, ListView, R10 -Multi Grid Count10 -Hdr xs y+5 gLv_Mouse AltSubmit, 内容|扩展
  Gui, Add, Edit, xs y+5 w480 h150 Disabled1 vShowNR
  LV_ModifyCol(1,420)
  LV_ModifyCol(2,50)
  Loadind()
  初始化热键()
Return
重启:
  Reload
Return
退出:
ExitApp
Return
GuiClose:
ShowOrHide:
  If (WinExist("ahk_id" NoteBQ)){
    WinGetpos, Gui_x, Gui_y, Gui_w, Gui_h, ahk_id %NoteBQ%
    IniWrite, % Gui_x, % A_WorkingDir "\Set.ini", GuiHotkey, Gui_x
    IniWrite, % Gui_y, % A_WorkingDir "\Set.ini", GuiHotkey, Gui_y
    Gui, Hide
  }
  Else {
    IniRead, Gui_x, % A_WorkingDir "\Set.ini", GuiHotkey, Gui_x
    IniRead, Gui_y, % A_WorkingDir "\Set.ini", GuiHotkey, Gui_y
    Gui, show, x%Gui_x% y%Gui_y%, 一个简单的记事工具
  }
Return
移动:
  Gui, Submit, NoHide
  HNumber := LV_GetNext()
  If (HNumber != 0) {
    LV_GetText(danhang, HNumber,1)
    LV_GetText(danhang2, HNumber,2)
    LV_Delete(HNumber)
    LV_Insert(目标行号, "Focus Select",danhang, danhang2)
  }
  Settimer, 更新记录, -300
Return
向上:
  HNumber := LV_GetNext()
  If (HNumber > 1) {
    LV_GetText(danhang, HNumber,1)
    LV_GetText(danhang2, HNumber,2)
    LV_Insert(HNumber-1, "Focus Select",danhang, danhang2)
    LV_Delete(HNumber+1)
  }
  Settimer, 更新记录, -300
Return
向下:
  HNumber := LV_GetNext()
  If (HNumber < LV_GetCount() && HNumber > 0) {
    LV_GetText(danhang, HNumber,1)
    LV_GetText(danhang2, HNumber,2)
    LV_Insert(HNumber+2, "Focus Select",danhang, danhang2)
    LV_Delete(HNumber)
  }
  Settimer, 更新记录, -300
Return
插入:
  Gui, Submit, NoHide
  If(Newjs) {
    HNumber := LV_GetNext()
    LV_Insert(HNumber := (HNumber = 0) ? 1 : HNumber, ,Newjs)
    GuiControl, Text, Newjs
    IniWrite, thi=, % A_WorkingDir "\js.ini", % Newjs
  }
  Settimer, 更新记录, -300
Return
新建:
  Gui, Submit, NoHide
  If(Newjs) {
    LV_Add(, Newjs)
    GuiControl, Text, Newjs
    IniWrite, thi=, % A_WorkingDir "\js.ini", % Newjs
  }
  Settimer, 更新记录, -300
Return
删除:
  HNumber := LV_GetNext()
  LV_GetText(HText, HNumber)
  If (HNumber != 0) {
    IniDelete, % A_WorkingDir "\js.ini", % HText
    LV_Delete(HNumber)
  }
  Settimer, 更新记录, -300
Return
Lv_Mouse:
  HNumber := LV_GetNext()
  Switch A_GuiEvent
  {
  Case "R":
    If (HNumber = 0)
      Return
    GuiControl, Enable, ShowNR
    LV_GetText(HText, HNumber)
    IniRead, ShowYl, % A_WorkingDir "\js.ini", % HText, thi
    If (ShowYl) {
      ShowYl := RegExReplace(ShowYl,"\\n","`n")
      GuiControl, Text, ShowNR, % ShowYl
    }
    Else {
      GuiControl, Text, ShowNR
    }
    OldHh := LV_GetNext()
    LV_GetText(OldText, OldHh)
  Case "RightClick":
    GuiControl, Text, ShowNR
  Case "Normal":
    If (OldHh) {
      Gui, Submit, NoHide
      ShowNR := RegExReplace(ShowNR,"[\n\r]+","\n")
      IniWrite, % ShowNR, % A_WorkingDir "\js.ini", % OldText, thi
      LV_Modify(OldHh, ,OldText, kv := (ShowNR) ? ">>>" : "")
    }
    GuiControl, Disabled, ShowNR
    Switch HNumber
    {
    Case 0:
      GuiControl, Text, ShowNR
    Default:
      LV_GetText(HText, HNumber)
      IniRead, ShowYl, % A_WorkingDir "\js.ini", % HText, thi
      If (ShowYl) {
        ShowYl := RegExReplace(ShowYl,"\\n","`n")
        GuiControl, Text, ShowNR, % ShowYl
      }
      Else
        GuiControl, Text, ShowNR
    }
    OldHh := "", OldText := ""
  }
  Return
  初始化热键(){
    If (FileExist(A_WorkingDir "\Set.ini")){
      IniRead, GuiHotkey, % A_WorkingDir "\Set.ini", GuiHotkey, SHkey
      If (GuiHotkey)
        Hotkey, % GuiHotkey, ShowOrHide
    } Else {
      IniWrite, ^F12, % A_WorkingDir "\Set.ini", GuiHotkey, SHkey
      IniWrite, 100, % A_WorkingDir "\Set.ini", GuiHotkey, Gui_x
      IniWrite, 100, % A_WorkingDir "\Set.ini", GuiHotkey, Gui_y
      Hotkey, ^F12, ShowOrHide
    }
  }
  Return
  Loadind(){
    cl := []
    IniRead, paixu, % A_WorkingDir "\Set.ini", paixu
    cl := StrSplit(paixu,"`n")
    For k,v in cl
      TxtCl .= v ","
    If (paixu) {
      Loop, Parse, paixu, `n, `r
      {
        IniRead, jishi, % A_WorkingDir "\js.ini", % A_LoopField, thi
        If (jishi="ERROR") {
          IniWrite, thi=, % A_WorkingDir "\js.ini", % A_LoopField
          LV_Add(, A_LoopField)
        }
        Else
          LV_Add(, A_LoopField, kv := (jishi) ? ">>>" : "")
      }
    }
    IniRead, paixu, % A_WorkingDir "\js.ini"
    If (paixu) {
      ; IniWrite, % paixu, % A_WorkingDir "\Set.ini", paixu
      Loop, Parse, paixu, `n, `r
      {
        If A_LoopField in %TxtCl%
          continue
        IniRead, jishi, % A_WorkingDir "\js.ini", % A_LoopField, thi
        If (jishi="ERROR") {
          IniWrite, thi=, % A_WorkingDir "\js.ini", % A_LoopField
          LV_Add(, A_LoopField)
        }
        Else
          LV_Add(, A_LoopField, kv := (jishi) ? ">>>" : "")
      }
    }
    Settimer, 更新记录, -300
  }
  Return
  更新记录:
    Loop % LV_GetCount()
    {
      LV_GetText(danhang, A_Index)
      If (A_Index = 1)
        paixu := danhang
      Else
        paixu .= "`n" danhang
    }
    IniDelete, % A_WorkingDir "\Set.ini", paixu
    IniWrite, % paixu, % A_WorkingDir "\Set.ini", paixu
  Return