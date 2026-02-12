图一乐  
将只信任一点的图形应用安装到容器里
```sh
cd build/debian
./build.sh debian:test
cd ../../root/home/public
./build.sh . ../debian .icons
cd ../../../..
./startdeb.sh debian:test
```

## gitignore的影响
```
build/debian/res/fonts/maple
build/kali/res/fonts/maple
缺失字体,放在home目录下.fonts好像也行

**/.Xauthority
运行X11, 宿主机上需要配置好$XAUTHORITY环境变量, 并用xauth generate $DISPLAY生成cookie

root/home/public/.icons/Papirus-Dark/*
部分gtk应用会因为缺失图标无法启动

root/home/public/.local/share/fcitx5
无
```

赛博积木说是😉