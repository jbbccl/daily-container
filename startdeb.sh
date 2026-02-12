#!/usr/bin/env bash
touch $XAUTHORITY
xauth generate $DISPLAY || true
cp $XAUTHORITY root/home/debian/.Xauthority

img_name="${1:-localhost/debian:daily}"
CONTAINER_NAME="debian"

ARGS=(
	--name "$CONTAINER_NAME"
	--rm
	-it
	# --detach				# 后台运行

	-e "DISPLAY=$DISPLAY" 
	-e "WAYLAND_DISPLAY=$WAYLAND_DISPLAY" 
	
	-v "/tmp/.X11-unix:/tmp/.X11-unix":ro 
	-v "$XDG_RUNTIME_DIR/pipewire-0:$XDG_RUNTIME_DIR/pipewire-0":ro 
	-v "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY":ro 

	-v "$(pwd)/root/home/debian:/home/a" 
	-v "$(pwd)/root/home/public:/home/public":ro 

	# systemd配置
	--systemd=always 
	-v "$(pwd)/root/etc/environment:/etc/environment" 
	# -v "$(pwd)/root/etc/systemd/autologin.conf:/etc/systemd/system/console-getty.service.d/autologin.conf" 
	
	--device /dev/dri:/dev/dri 
	--device /dev/snd:/dev/snd

	-h debian
	--network host
	--uts private
	--add-host debian:127.0.0.1
	# 权限这一块
	--ipc=private 
	--userns=keep-id 
	"$img_name"
	/sbin/init
)

podman rm -f "$CONTAINER_NAME" 2>/dev/null

podman run "${ARGS[@]}"