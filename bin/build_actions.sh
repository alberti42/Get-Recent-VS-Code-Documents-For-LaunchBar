#!/usr/bin/env bash
#
# build_actions.sh — Build the LaunchBar action and pack it into build/Get-Recent-VS-Code-Documents-For-LaunchBar.zip.
#
# Usage:
#   bin/build_actions.sh                     # signed ad hoc
#   bin/build_actions.sh "Developer ID Application: Andrea Alberti (9V3X7C8VCK)"
#
# What it does:
#   1. Copies the files of Actions/Recent VS Code Opened Files.lbaction that git tracks to
#      build/Actions/. Untracked files in the bundle, such as .DS_Store or
#      Contents/.claude/, stay out of the ZIP.
#   2. Compiles Stub/main.c for arm64 and x86_64 into the bundle's
#      Contents/MacOS/RecentVSCodeDocuments, the CFBundleExecutable. LaunchBar does
#      not run it; it runs Contents/Scripts/default.py.
#   3. Signs the bundle with the identity given as first argument ("-", ad hoc,
#      by default). A Developer ID signature gets the hardened runtime and a
#      secure timestamp, which notarization requires.
# Then it packs build/Actions/*.lbaction into build/Get-Recent-VS-Code-Documents-For-LaunchBar.zip.
#
# Gatekeeper rejects a downloaded action whose bundle is not signed and
# notarized. Apple's notary service issues tickets only for Mach-O code, so the
# bundle needs the stub as its executable: signing the bundle embeds the
# signature, which seals default.py, in the stub.

set -euo pipefail
cd "$(dirname "$0")/.."

IDENTITY="${1:--}"
EXE=RecentVSCodeDocuments
OUT=build/Actions
ZIP=build/Get-Recent-VS-Code-Documents-For-LaunchBar.zip

rm -rf "$OUT" "$ZIP"
mkdir -p "$OUT"

# ditto creates the parent folders and keeps the file mode (default.py is executable).
git ls-files -z -- Actions | while IFS= read -r -d '' F; do
    ditto "$F" "build/$F"
done

for BUNDLE in "$OUT"/*.lbaction; do
    echo "── ${BUNDLE#"$OUT"/}"
    plutil -lint "$BUNDLE/Contents/Info.plist"
    test "$(plutil -extract CFBundleExecutable raw "$BUNDLE/Contents/Info.plist")" = "$EXE"

    mkdir -p "$BUNDLE/Contents/MacOS"
    xcrun clang -arch arm64 -arch x86_64 -mmacosx-version-min=10.13 -O2 -Wall -Werror \
        -o "$BUNDLE/Contents/MacOS/$EXE" Stub/main.c

    ID=$(plutil -extract CFBundleIdentifier raw "$BUNDLE/Contents/Info.plist")
    if [[ "$IDENTITY" == "-" ]]; then
        codesign --force --sign - --identifier "$ID" "$BUNDLE"
    else
        codesign --force --sign "$IDENTITY" --identifier "$ID" \
            --options runtime --timestamp "$BUNDLE"
    fi
    codesign --verify --strict --deep "$BUNDLE"
    (cd "$BUNDLE" && find . -type f | sort)
done

# ditto keeps the bundle layout; --norsrc leaves out extended attributes.
(cd "$OUT" && ditto -c -k --norsrc . "../${ZIP#build/}")
echo "── $ZIP"
