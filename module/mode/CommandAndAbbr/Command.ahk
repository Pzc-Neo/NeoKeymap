; 需要在Neokeymap.ahk 中的 capsHook 中注册
; 执行capslock指令
execCapslockAbbr(typo) {
  switch typo 
  {
  case "bb":
    path = C:\Program Files\Google\Chrome\Application\chrome.exe
    ActivateOrRun("Bing 词典", path, "--app=https://cn.bing.com/dict/search?q=nice", "")
  return
case "cm":
  path =C:\Program Files\Microsoft VS Code\Code.exe
  ActivateOrRun("MyKeymap - Visual Studio Code", path, "D:\MyFiles\MyKeymap", "")
return 
case "ci":
  path =C:\Program Files\Microsoft VS Code\Code.exe
  ActivateOrRun("chm_im_generate_words_file - Visual Studio Code", path, "F:\neo_project\chm_im_generate_words_file", "")
return
case "cs":
  path =C:\Program Files\Microsoft VS Code\Code.exe
  ActivateOrRun("my_site - Visual Studio Code", path, "D:\project\my_site", "")
return
case "dd":
  run, shell:downloads
case "dm":
  run, %A_WorkingDir%
case "dp":
  run, shell:my pictures
case "dr":
  run, shell:RecycleBinFolder
case "dv":
  run, shell:My Video
case "dw":
  run, shell:Personal
case "ee":
  ToggleTopMost()
case "et":
  ; 用notepad++ 编辑temp.ahk
  path = C:\Program Files (x86)\Notepad++\notepad++.exe
  temp := % A_ScriptDir . "\data\lib\temp.ahk"
  ActivateOrRun("temp.ahk - notepad++.exe", path,temp,"")
return
case "ex":
  quit(false)
case "fw":
  path = %A_ProgramsCommon%\Google Chrome.lnk
  ActivateOrRun("", path, "", "")
return
case "fb":
  setColor("#2E66FF")
case "fg":
  setColor("#080")
case "fi":
  setColor("#FF00FF")
case "fp":
  setColor("#b309bb")
case "fr":
  setColor("#D05")
case "gg":
  path = C:\Program Files\Google\Chrome\Application\chrome.exe
  ActivateOrRun("Google 翻译", path, "--app=https://translate.google.cn/?op=translate&sl=auto&tl=zh-CN&text=nice", "")
return
case "io":
  path = %A_Programs%\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk
  ActivateOrRun("room-order-api ahk_exe idea64.exe", path, "D:\work\room-order-api", "")
return
case "ir":
  path = %A_Programs%\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk
  ActivateOrRun("room-api ahk_exe idea64.exe", path, "D:\work\room-api", "")
return
case "ld":
  run, module\tools\changeBrightness.ahk
  ;  run, module\ahk.exe module\changeBrightness.ahk
case "md":
  path = D:\project\my_site\docs\MyKeymap.md
  ActivateOrRun("MyKeymap.md - Typora", path, "", "")
return
case "mm":
  path = D:\notes\MyKeymap-Roadmap.md
  ActivateOrRun("MyKeymap-Roadmap.md - Typora", path, "", "")
return
case "mw":
  path = D:\notes\working.md
  ActivateOrRun("working.md - Typora", path, "", "")
return
case "no":
  path = C:\Program Files (x86)\Notepad++\notepad++.exe
  ActivateOrRun("ahk_exe notepad++.exe", path, "", "")
return
case "qq":
  path = D:\Program Files (x86)\Tencent\QQ\Bin\QQ.exe
  ActivateOrRun("ahk_exe QQ.exe", path, "", "")
return
case "rb":
  slideToReboot()
case "rex":
  restartExplorer()
case "sd":
  run, module\tools\soundControl.ahk
  ;  run, module\ahk.exe module\soundControl.ahk
  ; case "se":
  ;    openSettings()
case "sl":
  DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
return
case "ss":
  slideToShutdown()
case "st":
  path = shortcuts\Store.lnk
  ActivateOrRun("Microsoft Store", path, "", "")
return
case "we":
  path = C:\Program Files (x86)\Netease\CloudMusic\cloudmusic.exe 
  ActivateOrRun("ahk_exe cloudmusic.exe", path)
case "ws":
  run, module\tools\WindowSpy.ahk
  ;  run, module\ahk.exe module\soundControl.ahk
default: 
return false
}
return true
}
