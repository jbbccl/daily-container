FROM docker.io/library/debian:latest

ARG USERNAME=a
ARG USER_UID=1000
ARG USER_GID=1000
ARG HOST_DISPLAY=:1

USER root
WORKDIR /home/${USERNAME} 

# ADD res/fonts /usr/share/fonts

RUN <<EOF
	set -e 

	sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
	apt update && apt install -y --reinstall ca-certificates
	update-ca-certificates
	sed -i "s@http://@https://@g" /etc/apt/sources.list.d/debian.sources
	apt update
	apt upgrade -y

	apt install -y  \
		zsh zsh-autosuggestions zsh-syntax-highlighting zsh-common \
		dbus dbus-x11 dbus-daemon dbus-user-session \
		dconf-cli dconf-service dconf-gsettings-backend \
		locales \
		sudo

	echo "emulate sh -c '. /etc/profile'" > /etc/zsh/zprofile

	groupadd --gid ${USER_GID} ${USERNAME}|| true
	useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} -s /bin/zsh
	usermod -aG video,sudo,audio ${USERNAME}
	echo "${USERNAME}:kali" | chpasswd
	echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME}
	chmod 440 /etc/sudoers.d/${USERNAME}

	
	echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
	echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
	locale-gen
	echo 'LANG=zh_CN.UTF-8'  > /etc/locale.conf

	# fcitx5 fcitx5-rime 
	apt install -y \
		kitty fuzzel \
		libnspr4 libnss3  libegl1-mesa-dev libwayland-egl1 \
		libgtk-3-common libgtk-4-common
		
	apt clean
EOF

ENTRYPOINT ["/entrypoint.sh"]