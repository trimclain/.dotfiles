#!/bin/bash

#################################################
# Toggle nm-applet
#################################################
toggle_nm_applet() {
    pidloc="/tmp/nmappletpid"
    if [ -f "$pidloc" ]; then
        nmapid="$(cat $pidloc)"
        kill -15 "$nmapid"
        rm -f "$pidloc"
    else
        nm-applet & echo $! > "$pidloc"
    fi
}

toggle_nm_applet
