#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include, module\libs\AutoHotkey-JSON-master\JSON.ahk 

; config.ahk 和 config.json 必须放在同一个文件夹
; 名字也要一样

getConfigPath(){
  ; A_LineFile：当前脚本的绝对路径(不管是在哪里引用都是显示这个脚本文件所在的位置，
  ; 而不是显示引入这个脚本的那个脚本所在的位置)
  StringReplace, configPath, A_LineFile, .ahk, .json, All
  ; configPath: config.json文件所在的绝对路径
  Return configPath
}

readConfig(){
  configPath := getConfigPath()
  FileRead, jsonStr, % configPath
  config := JSON.load(jsonStr)
  Return config
}