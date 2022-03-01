﻿#NoEnv
#Persistent
#SingleInstance Force
#MaxHotkeysPerInterval 200
#NoTrayIcon

StringCaseSense, On
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
ListLines Off
settitlematchmode, 2

if (!WinExist("mykeymap-settings-server.exe")) {
    run, ..\setting\mykeymap-settings-server\mykeymap-settings-server.exe --server,, Hide
    run, ..\setting\mykeymap-settings-server\mykeymap-settings-server.exe --rain
    sleep, 1000
}

if WinExist("MyKeymap Settings")
    WinActivate
else
    run, http://127.0.0.1:12333
SetTimer, if_window_not_exists_then_close_process, 1000
return

if_window_not_exists_then_close_process()
{
    if !WinExist("mykeymap-settings-server.exe") {
        run, taskkill /f /im mykeymap-settings-server.exe,, Hide
        ExitApp
    }
}