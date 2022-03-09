Gui1 := new ShowInfo("First GUI")
Gui2 := new ShowInfo("First GUI")
Gui1.show("潘",true)
Gui2.show("潘")
Sleep, 500
Gui1.show("潘志")
Gui2.show("潘志")
Sleep, 500
Gui1.show("潘志城",true)
Gui2.show("潘志城")
Sleep, 500
; Gui1.show("P")
; Gui2.show("P")
; Sleep, 500
; Gui1.show("Pz",true)
; Gui2.show("Pz")
; Sleep, 500
; Gui1.show("Pzc",true)
; Gui2.show("Pzc")
; Sleep, 500
Gui1.show("潘志城_",true)
Gui2.show("潘志城_")
Sleep, 500
Gui1.show("潘志城_N",true)
Gui2.show("潘志城_N")
Sleep, 500
Gui1.show("潘志城_Ne",true)
Gui2.show("潘志城_Ne")
Sleep, 500
Gui1.show("潘志城_Neo",true)
Gui2.show("潘志城_Neo")
Sleep, 500
Gui1.hide()
Gui2.hide()

class ShowInfo
{
  __New(title := "", x := "", y := "") {

    this.controls := {}
    ; Gui, New, +hwndhGui +Disabled -SysMenu -Caption +E0x20 +AlwaysOnTop +Border, % title
    Gui, New , +hwndhGui +Owner +ToolWindow +Disabled -SysMenu -Caption +E0x20 +AlwaysOnTop +Border
    this.hwnd := hGui
    this.fontSize := 51
    this.defaultWidth := this.fontSize
    this.defaultHeight := this.fontSize*1.5

    global g_config
    Font_Colour := % g_config.style.fgColor ;0x2879ff
    Back_Colour := % g_config.style.bgColor ;0xffffe1 ; 0x34495e

    fontSize := this.fontSize 

    GUI, Margin, % fontSize/5, % fontSize / 5
    GUI, Color, % Back_Colour
    GUI, Font, c%Font_Colour% s%fontSize%, Microsoft Sans Serif

    defaultWidth := this.defaultWidth
    defaultHeight := this.defaultHeight
    static ControlID ; 存储控件 ID,  不同于 Hwnd
    GUI, Add, Text, vControlID w%defaultWidth% h%defaultHeight% center, %text%
    GuiControlGet, OutputVar, Hwnd , ControlID ; 获取 Hwnd
    this.textHwnd := OutputVar ; 保存到对象属性

    ; Gui, Add, Button, +hwndhButton x+-99 y+5 w100 h24, OK
  }
  show(text,isAbsolutePosition:= False) {
    gWidth := StrLen(text)*(this.fontSize) + this.defaultWidth
    GuiControl, Text, % this.textHwnd, %text% 
    GuiControl, Move, % this.textHwnd, w%gWidth%
    if(isAbsolutePosition){
      SysGet, currMon, Monitor, % current_monitor_index()
      ; GUI, show 
      ; wingetpos, X, Y, Width, Height, A ; , ahk_id %H_Tip%
      ; GUI, hide 
      xpos := (currMonRight + currMonLeft)/2.0 
      ypos := (currMonTop + currMonBottom) * 0.8
    }else{
      MouseGetPos, xpos, ypos 
      xpos += 10
      ypos += 7
    }
    Gui,Show, AutoSize Center NoActivate x%xpos% y%ypos% 
  }

  hide(){
    Gui, Hide
  }

  delete() {
    try Gui, % this.hwnd . ":Destroy"
    ; this.events.Clear()
  }
}