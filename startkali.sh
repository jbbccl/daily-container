#!/usr/bin/env bash
touch $XAUTHORITY
xauth generate $DISPLAY || true
cp $XAUTHORITY root/home/kali/.Xauthority

img_name="${1:-localhost/kali-linux:play}"
CONTAINER_NAME="kali"

ARGS=(
	--name "$CONTAINER_NAME"
	--rm
	-it
	# --detach

	-e "DISPLAY=$DISPLAY" 
	-e "WAYLAND_DISPLAY=$WAYLAND_DISPLAY" 
	
	-v "/tmp/.X11-unix:/tmp/.X11-unix":ro 
	-v "$XDG_RUNTIME_DIR/pipewire-0:$XDG_RUNTIME_DIR/pipewire-0":ro 
	-v "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY":ro

	-v "$(pwd)/root/home/kali:/home/a"
	-v "$(pwd)/root/home/public:/home/public":ro
	-v "$(pwd)/root/toolkit:/opt/toolkit"

	--systemd=always
	-v "$(pwd)/root/etc/environment:/etc/environment"
	-v "$(pwd)/root/etc/profile.d/toolkit.sh:/etc/profile.d/toolkit.sh"
	# -v "$(pwd)/root/etc/systemd/autologin.conf:/etc/systemd/system/console-getty.service.d/autologin.conf"
	
	--device /dev/dri:/dev/dri
	--device /dev/snd:/dev/snd
	
	-h kali 
	--network host
	--uts private
	--add-host kali:127.0.0.1
	
	--ipc=private
	--userns=keep-id 
	"$img_name"
	/sbin/init
	# zsh
)

podman rm -f "$CONTAINER_NAME" 2>/dev/null

podman run "${ARGS[@]}"