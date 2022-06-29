#!/usr/bin/env bash

# Color files
PFILE="$HOME/.config/polybar/colors.ini"
# RFILE="$HOME/.config/polybar/docky/scripts/rofi/colors.rasi"

# Change colors
change_color() {
    # polybar
    sed -i -e "s/; Theme: .*/; Theme: $THEME-dark/g" $PFILE
    sed -i -e 's/background = #.*/background = #292a30/g' $PFILE
    sed -i -e 's/background-alt = #.*/background-alt = #414453/g' $PFILE
    sed -i -e 's/foreground = #.*/foreground = #dfdfe0/g' $PFILE
    sed -i -e 's/foreground-alt = #.*/foreground-alt = #e7e8eb/g' $PFILE
    sed -i -e "s/primary = #.*/primary = $PC/g" $PFILE
    sed -i -e "s/secondary = #.*/secondary = $SC/g" $PFILE
    sed -i -e 's/alert = #.*/alert = #ff5555/g' $PFILE
    sed -i -e 's/disabled = #.*/disabled = #7f8c98/g' $PFILE

    # # rofi
    # cat > $RFILE << EOF
    # /* colors */
    #
    # * {
    #     al:   #00000000;
    #     bg:   #1F1F1FFF;
    #     bga:  ${PC}33;
    #     bar:  ${SC}FF;
    #     fg:   #FFFFFFFF;
    #     ac:   ${PC}FF;
    # }
    # EOF

    polybar-msg cmd restart
}

if  [[ $1 = "--amber" ]]; then
    THEME="amber"
    SC="#1F1F1F"
    PC="#ffb300"
    change_color
elif  [[ $1 = "--blue" ]]; then
    THEME="blue"
    SC="#FFFFFF"
    PC="#1e88e5"
    change_color
elif  [[ $1 = "--blue-gray" ]]; then
    THEME="blue-gray"
    SC="#FFFFFF"
    PC="#546e7a"
    change_color
elif  [[ $1 = "--brown" ]]; then
    THEME="brown"
    SC="#FFFFFF"
    PC="#6d4c41"
    change_color
elif  [[ $1 = "--cyan" ]]; then
    THEME="cyan"
    SC="#1F1F1F"
    PC="#00acc1"
    change_color
elif  [[ $1 = "--deep-orange" ]]; then
    THEME="deep-orange"
    SC="#FFFFFF"
    PC="#f4511e"
    change_color
elif  [[ $1 = "--deep-purple" ]]; then
    THEME="deep-purple"
    SC="#FFFFFF"
    PC="#5e35b1"
    change_color
elif  [[ $1 = "--green" ]]; then
    THEME="green"
    SC="#FFFFFF"
    PC="#43a047"
    change_color
elif  [[ $1 = "--gray" ]]; then
    THEME="gray"
    SC="#FFFFFF"
    PC="#757575"
    change_color
elif  [[ $1 = "--indigo" ]]; then
    THEME="indigo"
    SC="#FFFFFF"
    PC="#3949ab"
    change_color
elif  [[ $1 = "--light-blue" ]]; then
    THEME="light-blue"
    SC="#1F1F1F"
    PC="#039be5"
    change_color
elif  [[ $1 = "--light-green" ]]; then
    THEME="light-green"
    SC="#1F1F1F"
    PC="#7cb342"
    change_color
elif  [[ $1 = "--lime" ]]; then
    THEME="lime"
    SC="#1F1F1F"
    PC="#c0ca33"
    change_color
elif  [[ $1 = "--orange" ]]; then
    THEME="orange"
    SC="#1F1F1F"
    PC="#fb8c00"
    change_color
elif  [[ $1 = "--pink" ]]; then
    THEME="pink"
    SC="#FFFFFF"
    PC="#d81b60"
    change_color
elif  [[ $1 = "--purple" ]]; then
    THEME="purple"
    SC="#FFFFFF"
    PC="#8e24aa"
    change_color
elif  [[ $1 = "--red" ]]; then
    THEME="red"
    SC="#FFFFFF"
    PC="#e53935"
    change_color
elif  [[ $1 = "--teal" ]]; then
    THEME="teal"
    SC="#FFFFFF"
    PC="#00897b"
    change_color
elif  [[ $1 = "--yellow" ]]; then
    THEME="yellow"
    SC="#1F1F1F"
    PC="#fdd835"
    change_color
else
    cat << EOF
    No option specified, Available options:
    --amber	--blue		--blue-gray	--brown
    --cyan	--deep-orange	--deep-purple	--green
    --gray	--indigo	--light-blue	--light-green
    --lime	--orange	--pink		--purple
    --red	--teal		--yellow
EOF
fi
