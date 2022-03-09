; 符号模式
; 在这里添加的命令，也需要在 semiHook 里面添加
execSemicolonAbbr(typo) {
  switch typo 
  {
  case "ver":
    send, {blind}#r
    sleep 700
    send, {blind}winver{enter}
  return
case "zh":
  send, {blind}{text} site:zhihu.com
return
case "ss":
  send, {blind}{text}""
  send, {blind}{left}
return
case "xk":
  send, {blind}{text}()
  send, {blind}{left 1}
return
case "gg":
  send, {blind}{text}git add -A`; git commit -a -m ""`; git push origin (git branch --show-current)`;
  send, {blind}{left 47}
return
case "static":
  send, {blind}{text}https://static.xianyukang.com/
return
case "dk":
  send, {blind}{text}{}
  send, {blind}{left}
return
case "xm":
  send, {blind}{text}❖` ` 
return
case "jt":
  send, {blind}{text}➤` ` 
return
case "fs":
  send, {blind}{text}、
return
case "ff":
  send, {blind}{text}。
return
case "sm":
  send, {blind}{text}《》
  send, {blind}{left}
return
case "sk":
  send, {blind}{text}「 」
  send, {blind}{left 2}
return
case "sl":
  send, {blind}{text}【】
  send, {blind}{left 1}
return
case "fd":
  send, {blind}{text}，
return
case "gt":
  send, {blind}{text}🐶
return
case "lx":
  send, {blind}{text}💚
return
case "zk":
  send {blind}[]{left}
default: 
return false
}
return true
}