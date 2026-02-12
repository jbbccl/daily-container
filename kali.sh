#!/usr/bin/env bash
touch $XAUTHORITY
xauth generate $DISPLAY || true
cp $XAUTHORITY root/home/kali/.Xauthority
./mkenv.sh

img_name="${1:-localhost/kali-linux:play}"
CONTAINER_NAME="kali"

ENVS=()

ARGS=(
	--name "$CONTAINER_NAME"
	--rm
	-it
	--detach
	
	-v "/tmp/.X11-unix:/tmp/.X11-unix":ro 
	-v "$XDG_RUNTIME_DIR/pipewire-0:$XDG_RUNTIME_DIR/pipewire-0":ro 
	-v "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY":ro

	-v "$(pwd)/root/home/kali:/home/a"
	-v "$(pwd)/root/home/public:/home/public":ro
	-v "$(pwd)/root/toolkit:/opt/toolkit"
	
	-v "$(pwd)/root/share/fonts:/usr/local/share/fonts":ro
	-v "$(pwd)/root/share/icons/Papirus-Dark:/usr/share/icons/Papirus-Dark":ro
	
	

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
	# /sbin/init
	/sbin/init
	# /lib/systemd/systemd
)

podman rm -f "$CONTAINER_NAME" 2>/dev/null

podman run "${ARGS[@]}"

#pd exec -it --user a kali zsh -l -c "fuzzel&sh"