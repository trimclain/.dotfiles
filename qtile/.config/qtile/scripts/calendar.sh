#!/usr/bin/env bash

if [[ "$1" == "--today" ]] && command -v dunstify > /dev/null; then
    # show current month
    DAY=$(date +'%e')
    dunstify 'Calendar' "$(cal | sed -e "s/$DAY\b/<u>$DAY<\/u>/g")"
else
    # show current year
    # this part is for `terminal -e`
    cal -y | less
fi
