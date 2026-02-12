图一乐  
将只信任一点的图形应用安装到容器里
```sh
cd build/debian
./build.sh debian:test
cd ../../root/home/public
./build.sh . ../debian .icons
cd ../../..
./deb.sh debian:test
```

## gitignore的影响
```
build/debian/res/fonts/maple
build/kali/res/fonts/maple
缺失字体,放在home目录下.fonts好像也行

**/.Xauthority
运行X11, 宿主机上需要配置好$XAUTHORITY环境变量, 并用xauth generate $DISPLAY生成cookie

root/home/public/.icons/Papirus-Dark/*
部分gtk应用会因为缺失图标无法启动, sudo apt install papirus-icon-theme

root/home/public/.local/share/fcitx5
无
```

赛博积木说是😉

# 问题记录

## debian不执行/etc/profile

```sh
echo $0 
-zsh
```
登录shell为zsh,Zsh 启动时默认读取 /etc/zprofile 和 ~/.zprofile，在 /etc/zsh/zprofile 中加入
`emulate sh -c '. /etc/profile'` kali就是这么做的

## Failed to load image-missing.svg

XDG_DATA_DIRS不为空且不含/usr/local/share和/usr/share gtk应用就会出现下面报错
```sh
Gtk:ERROR:../../../gtk/gtkiconhelper.c:495:ensure_surface_for_gicon: assertion failed (error == NULL): Failed to load /home/a/.icons/Papirus-Dark/16x16@2x/actions/image-missing.svg: 无法识别的图像文件格式 (gdk-pixbuf-error-quark, 3)
Bail out! Gtk:ERROR:../../../gtk/gtkiconhelper.c:495:ensure_surface_for_gicon: assertion failed (error == NULL): Failed to load /home/a/.icons/Papirus-Dark/16x16@2x/actions/image-missing.svg: 无法识别的图像文件格式 (gdk-pixbuf-error-quark, 3)
```
[here](https://askubuntu.com/questions/1351607/gtk-warning-could-not-load-a-pixbuf-from-icon-theme)


## thunar首次启动慢

```sh
strace -r thunar 2>&1 | awk '($1 > 0.5) {print $0}'
12.233160 read(11, "\1\0\0\0\0\0\0\0", 8) = 8

G_MESSAGES_DEBUG=all thunar
(thunar:128): Gtk-DEBUG: 20:15:43.973: Failed to get the GNOME session proxy: The name org.gnome.SessionManager is not owned
(thunar:128): Gtk-DEBUG: 20:15:43.973: Failed to get the Xfce session proxy: The name org.xfce.SessionManager is not owned
(thunar:128): Gtk-DEBUG: 20:15:43.973: Failed to get an inhibit portal proxy: The name org.freedesktop.portal.Desktop is not owned
<--卡在此处
(thunar:128): thunar-DEBUG: 20:15:58.098: 得到会话消息总线 'org.xfce.FileManager'
```
禁用xdg-desktop-portal `export GTK_USE_PORTAL=0`
需要门户则
```sh
export GTK_USE_PORTAL=1
sudo apt install xdg-desktop-portal xdg-desktop-portal-gtk
/usr/libexec/xdg-desktop-portal 
```


## [FAILED] Failed to start polkit.service
屏蔽这个服务
```sh
sudo systemctl mask polkit.service
```