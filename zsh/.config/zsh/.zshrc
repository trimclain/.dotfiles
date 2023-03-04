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

###############################################################################
# Description:
# Since zsh searches for $HOME/.zshenv, put all necessary exports like $ZDOTDIR
# there. That way zsh know the new location of my config, which is following
# the XDG standarts (https://wiki.archlinux.org/title/XDG_Base_Directory)
# and is set to $XDG_CONFIG_HOME/zsh
#
# There are 2 folder for plugins. The first one is $ZDOTDIR/plugins. It contains
# small plugins mostly containing aliases. Those plugins will have to be updated
# manually if needed. The second folder is $XDG_DATA_HOME/zsh/plugins. Plugins
# are installed to that folder using custom functions from $ZDOTDIR/functions.zsh
###############################################################################

###############################################################################
# Zsh Settings
###############################################################################

# `man zshoptions` for description

# Make cd push the old directory onto the directory stack
setopt auto_pushd
# Don't push multiple copies of the same directory onto the directory stack
setopt pushd_ignore_dups
# Exchange the meanings of `+' and `-' when used with a number to specify a directory in the stack
setopt pushdminus
# If a command starts with a space, don't add it to a history
setopt histignorespace
# Don't save older commands that duplicate newer ones
setopt histsavenodups
# When using !! or !<number>, expand the command before running it
setopt histverify
# Allow comments in the interactive shell
setopt interactive_comments

# Disable highlighting on paste
zle_highlight=('paste:none')

# Disable all error sounds
unsetopt BEEP

# Disable ctrl-s to freeze and ctrl-q to unfreeze terminal
stty start undef stop undef

# Change the location of .zcompdump (https://unix.stackexchange.com/questions/391641/separate-path-for-zcompdump-files)
__ZCOMPDUMPDIR="$XDG_CACHE_HOME/zsh/"
export ZSH_COMPDUMP=$__ZCOMPDUMPDIR/zcompdump-$ZSH_VERSION
[[ -d $__ZCOMPDUMPDIR ]] || mkdir -p $__ZCOMPDUMPDIR
compinit -d "$ZSH_COMPDUMP"

###############################################################################
# Exports
###############################################################################

# Enable zap
# [ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh" || echo "Error: zap-zsh not found. Dont forget to delete ~/.antigen"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
    VIM="vim"
else
    export EDITOR='nvim'
    VIM="nvim"
fi

# Path to my dotfiles
export DOTFILES="$HOME/.dotfiles"

# History
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
export HISTORY_IGNORE="(ls|la|l|cd|cd -|cd ..|history|vim)"
setopt sharehistory

export CARGO="$HOME/.cargo/bin"
export N_PREFIX="$HOME/.n"
export GOROOT="$HOME/.golang"
export GOPATH="$HOME/.go"
export SDKMAN_DIR="$HOME/.sdkman"

###############################################################################
# Plugins
###############################################################################

source "$ZDOTDIR/functions.zsh"

# Git aliases
plug "git"

# Syntax highlighting bundle and autosuggestions
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"

# Load the theme.
source "$ZDOTDIR/plugins/colors/spaceship.zsh"
plug "spaceship-prompt/spaceship-prompt" "spaceship"
# plug "zap-zsh/zap-prompt"

###############################################################################
# Keybinds
###############################################################################

# (https://wiki.archlinux.org/title/zsh#Key_bindings)
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
# [[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
# [[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
# [[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# (https://wiki.archlinux.org/title/zsh#Shift,_Alt,_Ctrl_and_Meta_modifiers)
# Jump by word Using Ctrl + Left/Right
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

# TODO: jump to / if possible
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

###############################################################################

bindkey '^ ' autosuggest-accept

# open dotfiles in tmux
bindkey -s ^q "^utmux-sessionizer $DOTFILES\n"
# start tmux-sessionizer
bindkey -s ^t "^utmux-sessionizer\n"
# TODO: get help from cht.sh in tmux
# bindkey -s ^h "^utmux-cht.sh\n"
# bindkey -s ^b "^uchange-wallpaper\n"

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' '^ulfcd\n'

###############################################################################
# Aliases
###############################################################################

# source this config
alias szrc="exec zsh"

# preview images in kitty
alias icat="kitty +kitten icat"

if [[ $TERM == "xterm-kitty" ]]; then
    alias ssh="kitty +kitten ssh"
fi


alias vim="$VIM"
alias ebrc="$VIM $DOTFILES/bash/.bashrc --cmd \"cd $DOTFILES/bash/\""
alias ezrc="$VIM $DOTFILES/zsh/.zshrc --cmd \"cd $DOTFILES/zsh/\""
alias evrc="$VIM $DOTFILES/vim/.vimrc --cmd \"cd $DOTFILES/vim\""
alias enrc="$VIM $DOTFILES/nvim/.config/nvim/init.lua --cmd \"cd $DOTFILES/nvim/.config/nvim/\""

alias py="python3"

alias ls="ls --color=tty --group-directories-first"
alias la="ls -A"
alias l="ls -lhA"

if [[ -f ~/.local/bin/extract ]]; then
    alias ex=extract
fi

if [[ -f ~/.local/bin/archive ]]; then
    alias ar=archive
fi

###############################################################################
# Path
###############################################################################

# fucntion to add folders to the end of $PATH
addToPATH() {
    if [[ ! :$PATH: == *":$1:"* ]]; then
        PATH+=":$1"
    fi
}

# Make sure ~/.local/bin and /usr/local/bin are in $PATH.
addToPATH "/usr/local/bin"
addToPATH "$HOME/.local/bin"

addToPATH "$N_PREFIX/bin" # n-insall for node versions
addToPATH "$CARGO" # rust btw
addToPATH "$GOROOT/bin" # golang
addToPATH "$GOPATH/bin" # also golang

# Load aliases from .bash_aliases or .zsh_aliases if they exists
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
elif [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi
