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

# Path to my dotfiles
export DOTFILES="$HOME/.dotfiles"
export EDITOR="/usr/bin/vim"

# Useful variables to set
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

export CARGO="$HOME/.cargo/bin"
export N_PREFIX="$HOME/.n"
export GOROOT="$HOME/.golang"
export GOPATH="$HOME/.go"
export SDKMAN_DIR="$HOME/.sdkman"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color|xterm-kitty) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[00;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

bind '"\C-u": "Update\r"'


# Disable annoying error sound in terminal
bind 'set bell-style none'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

alias ebrc="vim $DOTFILES/bash/.bashrc --cmd \"cd $DOTFILES/bash/\""
alias evrc="vim $DOTFILES/vim/.vimrc --cmd \"cd $DOTFILES/vim\""

alias sbrc="source ~/.bashrc"
alias godf="cd ~/.dotfiles"

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
alias rest="./stop && ./start"

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

# fucntion to add folders to the end of $PATH
addToPATH() {
    if [[ ! :$PATH: == *":$1:"* ]]; then
        PATH+=":$1"
    fi
}


# Make sure ~/bin, ~/.local/bin and /usr/local/bin are in $PATH.
addToPATH "$HOME/bin"
addToPATH "/usr/local/bin"
addToPATH "$HOME/.local/bin"

addToPATH "$N_PREFIX/bin" # n-insall for node versions
addToPATH "$CARGO" # rust btw
addToPATH "$GOROOT/bin" # golang
addToPATH "$GOPATH/bin" # also golang

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi
