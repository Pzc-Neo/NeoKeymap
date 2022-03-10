getAbsolutePath(name){
  fullPath := A_LineFile 
  pos := InStr(fullPath, "\",, 0)
  absolutePath := substr(fullPath, 1, pos)
  MsgBox, absolutePath
  Return % absolutePath . name
}