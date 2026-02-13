#!/usr/bin/env bash


src=${1%/} dst=${2%/}
[[ -d $src ]] || { echo -e "Usage: $0 src dst excl...\n ./build.sh . ../kali .icons .fonts"; exit 1; }
mkdir -p "$dst"
args=(find "$src" -type f)
for e in "${@:3}"; do 
	args+=(! -path "$src/$e/*"); 
	ln -srf "$src/$e" "$dst"
done

args+=(-print0)
"${args[@]}" | while IFS= read -r -d '' f; do
	rel="${f#$src/}"
	mkdir -p "$dst/$(dirname "$rel")"
	ln -srf "$f" "$dst/$rel"
done

rm "$dst/$0"

#chmod -R a-w .
#rsync -Lr icons icon
# cp -Lr src dst
