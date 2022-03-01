;最钟爱代码之音量随心所欲
;=========================================================
~lbutton & enter:: ;鼠标放在任务栏，滚动滚轮实现音量的加减
exitapp  
~WheelUp::  
  if (existclass("ahk_class Shell_TrayWnd")=1)  
  Send,{Volume_Up}  
Return  
~WheelDown::  
  if (existclass("ahk_class Shell_TrayWnd")=1)  
    Send,{Volume_Down}  
Return  
~MButton::  
  if (existclass("ahk_class Shell_TrayWnd")=1)  
    Send,{Volume_Mute}  
Return  

Existclass(class)  
{  
  MouseGetPos,,,win  
  WinGet,winid,id,%class%  
  if win = %winid%  
  Return,1  
  Else  
  Return,0  
}

;=========================================================
^!+t:: ;小海原创-无敌工作神器之终极计时器
var := 0
InputBox, time, 小海御用计时器, 请输入一个时间（单位是分）
time := time*60000
Sleep,%time%
loop,16
{
var += 180
SoundBeep, var, 500
}
msgbox 时间到，啊啊啊！！！红红火火！！！恍恍惚惚！！！
return
;=========================================================