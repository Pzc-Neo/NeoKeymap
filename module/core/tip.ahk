class TypoTipWindow
{
  __New()
  {
    text := " " ; 初始化 text control 的宽度
    fontSize := 21
    this.fontSize := fontSize

    global gConfig
    Font_Colour := % gConfig.style.fgColor ;0x2879ff
    Back_Colour := % gConfig.style.bgColor ;0xffffe1 ; 0x34495e

    Gui, TYPO_TIP_WINDOW:New, +hwndhGui, ` 
    this.hwnd := hGui ; 保存 hwnd 目前没什么用

    Gui, +Owner +ToolWindow +Disabled -SysMenu -Caption +E0x20 +AlwaysOnTop +Border
    GUI, Margin, % fontSize/5, % fontSize / 5
    GUI, Color, % Back_Colour
    GUI, Font, c%Font_Colour% s%fontSize%, Microsoft Sans Serif

    static ControlID ; 存储控件 ID,  不同于 Hwnd
    GUI, Add, Text, vControlID w50 h30 center, %text%
    GuiControlGet, OutputVar, Hwnd , ControlID ; 获取 Hwnd
    this.textHwnd := OutputVar ; 保存到对象属性

    Gui, TYPO_TIP_WINDOW:Show, Hide
  }

  ; isAbsolutePosition: 是不是绝对定位，还是相对于鼠标定位。
  show(text,isAbsolutePosition:= False) {
    gWidth := StrLen(text)*(this.fontSize)
    GuiControl, Text, % this.textHwnd, %text% 
    GuiControl, Move, % this.textHwnd, w%gWidth%
    if(isAbsolutePosition){
      SysGet, currMon, Monitor, % current_monitor_index()
      GUI, show 
      wingetpos, X, Y, Width, Height, A ; , ahk_id %H_Tip%
      GUI, hide 
      xpos := (currMonRight + currMonLeft)/2.0 - Width/2.0
      ypos := (currMonTop + currMonBottom) * 0.8
    }else{
      MouseGetPos, xpos, ypos 
      xpos += 10
      ypos += 7
    }
    Gui, TYPO_TIP_WINDOW:Show, AutoSize Center NoActivate x%xpos% y%ypos% 
  }

  hide() {
    Gui, TYPO_TIP_WINDOW:Show, Hide
  }
}
