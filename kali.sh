#!/usr/bin/env bash
touch $XAUTHORITY
xauth generate $DISPLAY || true
cp $XAUTHORITY root/home/kali/.Xauthority
./mkenv.sh

img_name="${1:-localhost/kali-linux:play}"
CONTAINER_NAME="kali"

USER_NAME="a"
CONTAINER_HOME="/home/$USER_NAME"

ENVS=(
	-e "DISPLAY=$DISPLAY"
	-e "WAYLAND_DISPLAY=$WAYLAND_DISPLAY"
	-e "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
	-e "DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS"
	-e "ZDOTDIR=$CONTAINER_HOME/.config/zsh"

	-e "XDG_SESSION_DESKTOP=labwc"
	-e "XDG_VTNR=1"
	-e "XDG_SESSION_TYPE=wayland"
	-e "XDG_SEAT=seat0"
	-e "XDG_MENU_PREFIX=gnome-"
	-e "XDG_SESSION_ID=3"
	-e "XDG_CURRENT_DESKTOP=labwc"

	-e "NO_AT_BRIDGE=1"
	-e "LANG=zh_CN.UTF-8"
	-e "LANGUAGE=zh_CN:zh"
	-e "LC_ALL=zh_CN.UTF-8"
	-e "TZ=Asia/Shanghai"

	-e "QT_AUTO_SCREEN_SCALE_FACTOR=0"
	-e "QT_QPA_PLATFORMTHEME_QT6=gtk3"
	-e "QT_QPA_PLATFORMTHEME=gtk3"

	-e "GDK_BACKEND=wayland"
	-e "QT_QPA_PLATFORM=wayland"
	-e "SDL_VIDEODRIVER=wayland"
	-e "MOZ_ENABLE_WAYLAND=1"

	-e "GTK_USE_PORTAL=0"
)

ARGS=(
	--name "$CONTAINER_NAME"
	--rm
	-it
	# --detach
	--user "$USER_NAME"

	-v "/tmp/.X11-unix:/tmp/.X11-unix":ro 
	-v "$XDG_RUNTIME_DIR/pipewire-0:$XDG_RUNTIME_DIR/pipewire-0":ro 
	-v "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY":ro
	-v "$XDG_RUNTIME_DIR/bus:$XDG_RUNTIME_DIR/bus":ro 


	-v "$(pwd)/root/home/kali:/home/a"
	-v "$(pwd)/root/home/public:/home/public":ro
	-v "$(pwd)/root/toolkit:/opt/toolkit"
	
	-v "$(pwd)/root/share/fonts:/usr/local/share/fonts":ro
	-v "$(pwd)/root/share/icons/Papirus-Dark:/usr/share/icons/Papirus-Dark":ro
	
	--device /dev/dri:/dev/dri
	--device /dev/snd:/dev/snd
	
	-h kali 
	--network host
	--uts private
	--add-host kali:127.0.0.1
	
	--ipc=private
	--userns=keep-id 
	"$img_name"
	zsh -l
)

podman rm -f "$CONTAINER_NAME" 2>/dev/null

podman run "${ENVS[@]}" "${ARGS[@]}"

# pd exec -it --user a kali zsh -l -c "fuzzel&sh"