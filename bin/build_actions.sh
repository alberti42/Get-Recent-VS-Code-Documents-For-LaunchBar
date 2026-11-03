#!/usr/bin/env bash
#
# build_actions.sh — Pack the LaunchBar action into build/Get-Recent-VS-Code-Documents-For-LaunchBar.zip.
#
# Usage:
#   bin/build_actions.sh
#
# The action runs a Python script and contains no compiled code, so nothing is
# built or signed. The script:
#   1. Copies Actions/*.lbaction to build/Actions/, without __pycache__ and .DS_Store.
#   2. Sets the permissions to rwxr-xr-x for folders and scripts, rw-r--r-- for other files.
#   3. Packs build/Actions/*.lbaction into build/Get-Recent-VS-Code-Documents-For-LaunchBar.zip.

set -euo pipefail
cd "$(dirname "$0")/.."

OUT=build/Actions
ZIP=build/Get-Recent-VS-Code-Documents-For-LaunchBar.zip

rm -rf "$OUT" "$ZIP"
mkdir -p "$OUT"

for SRC in Actions/*.lbaction; do
    BUNDLE="$OUT/$(basename "$SRC")"
    echo "── $(basename "$SRC")"
    cp -R "$SRC" "$BUNDLE"
    find "$BUNDLE" \( -name __pycache__ -o -name .DS_Store \) -prune -exec rm -rf {} +
    chmod -R u=rwX,go=rX "$BUNDLE"
    chmod 755 "$BUNDLE"/Contents/Scripts/*
    plutil -lint -s "$BUNDLE/Contents/Info.plist"
done

# ditto keeps the bundle layout; --norsrc leaves out extended attributes.
(cd "$OUT" && ditto -c -k --norsrc . "../${ZIP#build/}")
echo "── $ZIP"
