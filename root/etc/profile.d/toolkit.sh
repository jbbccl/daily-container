#!/usr/bin/env bash

export PATH="/opt/toolkit/ass/bin:${PATH}"

export XDG_DATA_DIRS="/opt/toolkit/ass:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

export ZDOTDIR="$HOME/.config/zsh"

# fcitx5 >/dev/null 2>&1 &
