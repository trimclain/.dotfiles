#!/usr/bin/env bash
selected=`cat ~/.tmux-cht-languages ~/.tmux-cht-command | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

# Check if a language was selected; grep -q for quiet and -s for no messages
if grep -qs "$selected" ~/.tmux-cht-languages; then
    query=`echo $query | tr ' ' '+'`
    # Check if in tmux
    if [ -n "$TMUX" ]; then
        tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
    else
        bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query"
    fi
else
    if [ -n "$TMUX" ]; then
        tmux neww bash -c "curl -s cht.sh/$selected~$query | less"
    else
        bash -c "curl -s cht.sh/$selected~$query | less"
    fi
fi
