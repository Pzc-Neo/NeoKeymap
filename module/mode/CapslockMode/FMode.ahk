; capslock 的 f mode
#if FMode
  f::return

,::
  global CapslockF__comma
  bindOrActivate(CapslockF__comma)
return
M::
  global CapslockF__M
  bindOrActivate(CapslockF__M)
return
N::
  global CapslockF__N
  bindOrActivate(CapslockF__N)
return
K::
  path = %A_ProgramFiles%\DAUM\PotPlayer\PotPlayerMini64.exe
  workingDir = 
  ActivateOrRun("ahk_class PotPlayer64", path, "", workingDir)
return
Q::
  path = %A_ProgramFiles%\Everything\Everything.exe
  ActivateOrRun("ahk_class EVERYTHING", path)
return
U::
  path = %A_Programs%\JetBrains Toolbox\DataGrip.lnk
  ActivateOrRun("ahk_exe datagrip64.exe", path)
return
J::
  path = %A_Programs%\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk
  ActivateOrRun("ahk_exe idea64.exe", path, "", "")
return
S::
  path =C:\Program Files\Microsoft VS Code\Code.exe
  ActivateOrRun("ahk_exe Code.exe", path)
return
W::
  ; path = %A_ProgramsCommon%\Google Chrome.lnk
  path = C:\Users\Administrator.USER-20181115EQ\AppData\Local\360Chrome\Chrome\Application\360chrome.exe
  ActivateOrRun("ahk_exe 360chrome.exe", path)
return
Y::
  path = C:\Program Files (x86)\Youdao\YoudaoNote\YoudaoNote.exe 
  ActivateOrRun("ahk_exe YoudaoNote.exe", path)
return
D::
  path = C:\Program Files (x86)\Notepad++\notepad++.exe
  ActivateOrRun("ahk_exe notepad++.exe", path, "", "")
return
H::
  path = %A_ProgramsCommon%\Visual Studio 2019.lnk
  ActivateOrRun("- Microsoft Visual Studio", path)
return
E::
  ; path = C:\Program Files (x86)\Youdao\YoudaoNote\YoudaoNote.exe
  ; ActivateOrRun("ahk_exe YoudaoNote.exe", path)
  path = E:\Program Files\VNote\VNote.exe
  ActivateOrRun("ahk_exe VNote.exe", path)
return
I::
  path = C:\Program Files\Typora\Typora.exe
  ActivateOrRun("ahk_exe Typora.exe", path)
return
L::
  path = C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk
  workingDir = 
  ActivateOrRun("ahk_exe EXCEL.EXE", path, "", workingDir)
return
P::
  ; window terminal 
  path =C:\Users\Administrator.USER-20181115EQ\AppData\Local\Microsoft\WindowsApps\wt.exe 
  ; path = C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
  ;true 表示用管理员模式运行
  ActivateOrRun("ahk_exe WindowsTerminal.exe", path, "", "",true)
return
Z::
  path = D:\
  ActivateOrRun("ahk_class CabinetWClass ahk_exe Explorer.EXE", path)
return
R::
  path = D:\install\Foxit Reader\FoxitReader.exe
  ActivateOrRun("ahk_exe FoxitReader.exe", path)
return
O::
  path = shortcuts\OneNote for Windows 10.lnk
    ActivateOrRun("OneNote for Windows 10", path)
return
A::
  ; Run, %ComSpec% /k ping 8.8.8.8
  path = %windir%\system32\cmd.exe
  ActivateOrRun("ahk_exe cmd.exe", path)

return
B::
  path = "E:\Program Files\BookxNote Pro\BookxNotePro.exe"
  ActivateOrRun("ahk_exe BookxNotePro.exe", path)
return
#If