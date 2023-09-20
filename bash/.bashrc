###############################################################################
#        ______ ___    __ __   ___    ____  __     __     __  __   __         #
#       /_  __//   \  / //  \ /   |  / __/ / /    /  |   / / /  \ / /         #
#        / /  /   _/ / // /\\/ /| | / /   / /    /   |  / / / /\\/ /          #
#       / /  / /\ \ / // / \/_/ | |/ /__ / /___ / _  | / / / / \/ /           #
#      /_/  /_/ \_\/_//_/       |_|\___//_____//_/ \_|/_/ /_/  /_/            #
#                                                                             #
#                                                                             #
#       Arthur McLain (trimclain)                                             #
#       mclain.it@gmail.com                                                   #
#       https://github.com/trimclain                                          #
#                                                                             #
###############################################################################

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Path to my dotfiles
export DOTFILES="$HOME/.dotfiles"
export EDITOR="/usr/bin/vim"
export VISUAL=$EDITOR

# Useful variables to set
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

export N_PREFIX="$HOME/.n"
# export GOROOT="$HOME/.golang"
# export GOPATH="$HOME/.go"
export SDKMAN_DIR="$HOME/.sdkman"

###############################################################################
# Less
###############################################################################
export PAGER=less
export LESSCHARSET="UTF-8"
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
export LESS='-i -n -w -M -R -P%t?f%f \
    :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;11m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
###############################################################################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

###############################################################################
# do i need this?
###############################################################################
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
###############################################################################

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color|xterm-kitty|screen) color_prompt=yes ;;
esac

if [ "$color_prompt" = yes ]; then
    # inspired by ubuntu defaults
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

    # inspired by arch defaults
    # PS1='[\[\033[01;32m\]\u@\h\[\033[00m\]: \[\033[01;34m\]\W\[\033[00m\]]\$ '

    # inspired by Luke Smith
    PS1='\[\033[01;31m\][\[\033[00m\]\[\033[01;33m\]\u\[\033[00m\]\[\033[01;32m\]@\[\033[00m\]\[\033[01;34m\]\h\[\033[00m\]: \[\033[01;35m\]\W\[\033[00m\]\[\033[01;31m\]]\[\033[00m\]$ '
else
    # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='[\u@\h \W]\$ '
fi
unset color_prompt


# Keybinds
if [[ -f ~/.local/bin/tmux-sessionizer ]]; then
    bind '"\C-t": "tmux-sessionizer $DOTFILES\n"'
fi

# Disable annoying error sound in terminal
bind 'set bell-style none'

# My Aliases
alias ebrc="vim $DOTFILES/bash/.bashrc --cmd \"cd $DOTFILES/bash/\""
alias evrc="vim $DOTFILES/vim/.vimrc --cmd \"cd $DOTFILES/vim\""

alias sbrc="source ~/.bashrc"
alias godf="cd ~/.dotfiles"

alias grep='grep --color=auto'

alias ls='ls --color=auto'
alias la="ls -A --group-directories-first"
alias l="ls -lhA --group-directories-first"

if [ -f ~/.zsh_aliases ]; then
    alias eals="vim ~/.zsh_aliases"
    alias showals="cat ~/.zsh_aliases"
elif [ -f ~/.bash_aliases ]; then
    alias eals="vim ~/.bash_aliases"
    alias showals="cat ~/.bash_aliases"
fi

alias py="python3"
alias activate="source venv/bin/activate"

# Load aliases from .zsh_aliases or .bash_aliases if they exist
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
elif [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# add folders to the beginning of $PATH
addToPATH() {
    if [[ -d "$1" ]] && [[ ! :$PATH: == *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# Make sure ~/.local/bin and /usr/local/bin are in $PATH.
addToPATH "/usr/local/bin"
addToPATH "$HOME/.local/bin"

addToPATH "$N_PREFIX/bin" # n-insall for node versions
# addToPATH "$GOROOT/bin" # golang
# addToPATH "$GOPATH/bin" # also golang
addToPATH "$HOME/.juliaup/bin" # julia

# enable sdkman (jdk version manager)
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi
