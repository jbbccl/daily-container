#!/usr/bin/env bash
# build.sh

img_name="${1:-localhost/kali-linux:play}"
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)
HOST_DISPLAY=$DISPLAY

echo "Building $img_name with UID: $CURRENT_UID, GID: $CURRENT_GID, HOST_DISPLAY:$HOST_DISPLAY"

podman build \
  --build-arg USERNAME=a \
  --build-arg USER_UID=$CURRENT_UID \
  --build-arg USER_GID=$CURRENT_GID \
  --build-arg HOST_DISPLAY=$HOST_DISPLAY \
  -t "$img_name" .
