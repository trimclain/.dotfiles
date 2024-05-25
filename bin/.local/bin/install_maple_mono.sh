#!/usr/bin/env bash

# Install latest Maple Mono Release/Pre-release
# Reason: AUR gets only latest release and the guy likes Pre-releases
# Requires: curl, unzip, fc-cache (fontconfig)

FONT_DIR="$HOME/.local/share/fonts"
URL=https://api.github.com/repos/subframe7536/maple-font/releases

# Get latest release
TAG_NAMES=$(curl -s "$URL" |
	awk -v RS=',' -F'"' '/tag_name/ {print $4}')

RELEASES=()
while IFS= read -r line; do
	RELEASES+=("$line")
done <<<"$TAG_NAMES"

if [[ -n "$1" ]]; then
	latest="v6.4"
else
	latest="${RELEASES[0]}"
fi


# Install
echo "Installing MapleMono-NF $latest"

pushd /tmp || exit

opts=("--location" "--remote-header-name" "--remote-name" "--progress-bar")
curl "${opts[@]}" "https://github.com/subframe7536/maple-font/releases/download/$latest/MapleMono-NF.zip"

rm -rf "$FONT_DIR/MapleMono-NF"
mkdir -p "$FONT_DIR/MapleMono-NF"
unzip "MapleMono-NF.zip" -d "$FONT_DIR/MapleMono-NF"

rm -f "MapleMono-NF.zip"

popd || exit

echo "Done"

# Update font cache
fc-cache
