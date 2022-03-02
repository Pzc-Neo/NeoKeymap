# 说明

## 前言

修改自：[MyKeymap](https://github.com/xianyukang/MyKeymap)

因为鼠标用多了手会很累，甚至会痛。所以我一直在寻找全键盘方案，但是只找到了浏览器上面的，电脑上面的一直找不到。

现在找到的这个`MyKeymap`，简直就是神器。虽然有些设置不符合我的使用习惯，但是那些地方，自己改改就好了。

顺便说一下，浏览器上我之前用的用的是`vimium`，现在用的是[surfingkey](https://github.com/brookhong/Surfingkeys)

## 不用原版的原因

### 很多键不能自定义，或者说自定义很麻烦

需要在 template 那里修改，不然每次改设置，之前修改的内容斗会都会被重置。

## 修改的内容

### 去掉了配置网页和启动器

**关于配置**
一般来说配置完之后会一直用下去，不会经常修改。所以配置页面对于我来说不是必须的。

更何况需要修改或者添加内容的时候，直接进入改源码就行。

**关于启动器**
就是那个 MyKeymaps.exe 和那一大堆的`dll`，貌似不是必须的，毕竟我的电脑本身就装了`autohotkey`，所以把它们去掉了，只剩下`.ahk`文件和图标之类的。

就算在没有装 autohotkey 的电脑上面用，也可以直接把`.ahk`文件编译成 exe。

### capslock 指令键->右 shift 键

我是用 `vim` 的，为了顺手把`capslock`键映射成`esc`，所以经常会误触。

虽然可以用`j+x`来实现 `esc` 的功能，但是按两个键总没有按一个键来得舒服，而且有时候未必两个手都在键盘上面的。比如浏览网页的时候，我可能只有左手在键盘上。

## 未解决的bugs

### 点击任务栏图标没反应

**信息**
OS 名称: Microsoft Windows 10 教育版
OS 版本: 10.0.18362 暂缺 Build 18362

原版没这个问题，不过这个bug对我来说影响不大，所以暂时不管。
