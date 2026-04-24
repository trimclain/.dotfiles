#!/usr/bin/env bash

# shellcheck disable=SC2016

if command -v kitty > /dev/null; then
    terminal="kitty -e"
elif command -v alacritty > /dev/null; then
    terminal="alacritty -e"
elif command -v xfce4-terminal > /dev/null; then
    terminal="xfce4-terminal -x"
else
    notify-send "Error: no terminal application found."
    exit 1
fi

if [[ "$1" == "--today" ]]; then
    # show current month
    if command -v dunstify > /dev/null; then
        DAY=$(date +'%e')
        dunstify 'Calendar' "$(cal | sed -e "s/$DAY\b/<u>$DAY<\/u>/g")"
    else
        $terminal sh -c 'cal | GREP_COLORS="mt=1;32" grep --color=always -E "\\b$(date +%-d)\\b|$" | less -R'
    fi
else
    # show current year (yep, it's this hard to show current day in less)
    $terminal sh -c '
    color="\033[1;32m"   # bright magenta
    reset="\033[0m"

    m=$(date +%-m)
    d=$(date +%-d)

    cal -y |
    awk -v m="$m" -v d="$d" -v color="$color" -v reset="$reset" "
    BEGIN {
      row = int((m-1)/3)
      col = (m-1)%3
      start = row*8 + 1
      end = start + 7
    }
    NR < start || NR > end { print; next }
    {
      if (NR == start || NR == start+1) { print; next }
      line = \$0
      from = col*22 + 1
      part = substr(line, from, 20)

      if (match(part, \"(^|[[:space:]])\" d \"([[:space:]]|$)\")) {
        pre  = substr(part, 1, RSTART-1)
        hit  = substr(part, RSTART, RLENGTH)
        gsub(d, color d reset, hit)
        post = substr(part, RSTART+RLENGTH)
        part = pre hit post
      }

      print substr(line, 1, from-1) part substr(line, from+20)
    }
    " | less -R
    '
fi
