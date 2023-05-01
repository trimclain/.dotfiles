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
# there. That way zsh knows the new location of my config, which is following
# the XDG standarts (https://wiki.archlinux.org/title/XDG_Base_Directory)
# set to $XDG_CONFIG_HOME/zsh
#
# There are 2 folder for plugins. The first one is $ZDOTDIR/plugins. It contains
# small plugins mostly containing aliases. Those plugins will have to be updated
# manually if needed. The second folder is $XDG_DATA_HOME/zap/plugins. Plugins
# in that folder are managed by zap.
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

# Completion
# Highlight seleceted options on <Tab>
zstyle ':completion:*' menu select

# Disable all error sounds
unsetopt BEEP

# Disable ctrl-s to freeze and ctrl-q to unfreeze terminal
stty start undef stop undef

# Change the location of .zcompdump (https://unix.stackexchange.com/questions/391641/separate-path-for-zcompdump-files)
autoload -Uz compinit
__ZCOMPDUMPDIR="$XDG_CACHE_HOME/zsh/"
[[ -d $__ZCOMPDUMPDIR ]] || mkdir -p $__ZCOMPDUMPDIR
export ZSH_COMPDUMP=$__ZCOMPDUMPDIR/zcompdump-$ZSH_VERSION
compinit -d "$ZSH_COMPDUMP"

###############################################################################
# Exports
###############################################################################

# Preferred editor for local and remote sessions
[[ -n $SSH_CONNECTION ]] && export EDITOR='/usr/bin/vim' || export EDITOR='/usr/local/bin/nvim'

# Path to my dotfiles
export DOTFILES="$HOME/.dotfiles"

# History
export HISTFILE=$HOME/.zsh_history
# export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=10000
export SAVEHIST=10000
export HISTORY_IGNORE="(ls|la|l|cd|cd -|cd ..|history|vim)"
setopt sharehistory

export CARGO="$HOME/.cargo"
export N_PREFIX="$HOME/.n"
export GOROOT="$HOME/.golang"
export GOPATH="$HOME/.go"
export SDKMAN_DIR="$HOME/.sdkman"

###############################################################################
# vi mode
###############################################################################

# https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] ||
    [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] ||
    [[ ${KEYMAP} == viins ]] ||
    [[ ${KEYMAP} = '' ]] ||
    [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Edit line in vim with ctrl-e
autoload edit-command-line;zle -N edit-command-line
bindkey '^e' edit-command-line

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

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# Delete word on Ctrl + Backspace (yeah, C-h is for some reason same as C-B)
bindkey '^H' backward-kill-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# From /usr/share/doc/fzf/examples/key-bindings.zsh
# CTRL-R - Paste the selected command from history into the command line
__fzfcmd() {
    [ -n "$TMUX_PANE" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}
if command -v fzf &> /dev/null; then
    fzf-history-widget() {
        local selected num
        setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
        selected=( $(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' |
        FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
        local ret=$?
        if [ -n "$selected" ]; then
            num=$selected[1]
            if [ -n "$num" ]; then
                zle vi-fetch-history -n $num
            fi
        fi
        zle reset-prompt
        return $ret
    }
    zle     -N   fzf-history-widget
    bindkey '^R' fzf-history-widget
fi

###############################################################################

bindkey '^ ' autosuggest-accept

# open dotfiles in tmux (use -s with bindkey when binding to custom command)
bindkey -s ^q "^utmux-sessionizer $DOTFILES\n"
# start tmux-sessionizer
bindkey -s ^t "^utmux-sessionizer\n"
# get help from cht.sh in tmux on Ctrl+?
bindkey -s ^_ "^utmux-chtsh\n"
# bindkey -s ^b "^uchange-wallpaper\n"

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    # `command` is needed in case `lfcd` is aliased to `lf`
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir" || return 0
    fi
}
bindkey -s '^o' '^ulfcd\n'

###############################################################################
# Aliases
###############################################################################

# source this config
alias szrc="exec zsh"

# Kittens
if [[ $TERM == "xterm-kitty" ]]; then
    alias ssh="kitty +kitten ssh"
    # preview images in kitty
    alias icat="kitty +kitten icat"
fi

alias vim="$EDITOR"
alias ebrc="$EDITOR $DOTFILES/bash/.bashrc --cmd \"cd $DOTFILES/bash/\""
alias ezrc="$EDITOR $DOTFILES/zsh/.config/zsh/.zshrc --cmd \"cd $DOTFILES/zsh/\""
alias evrc="$EDITOR $DOTFILES/vim/.vimrc --cmd \"cd $DOTFILES/vim\""
alias enrc="$EDITOR $DOTFILES/nvim/.config/nvim/init.lua --cmd \"cd $DOTFILES/nvim/.config/nvim/\""

alias py="python3"

# zsh specific syntax for checking if command exists
if (( $+commands[exa] )); then
    alias ls='exa --group-directories-first --icons'
    alias la='ls -a'
    alias l='ls -lha'
    alias ll='ls -lh'
    alias tree='ll --tree --level=2'
else
    alias ls="ls --color=tty --group-directories-first"
    alias la="ls -A"
    alias l="ls -lhA"
fi

if (( $+commands[bat] )); then
    alias cat="bat -pp --theme \"DarkNeon\""
    alias catt="bat --theme \"DarkNeon\""
elif (( $+commands[batcat] )); then
    # Ubuntu...
    alias bat="batcat"
    alias cat="bat -pp --theme \"DarkNeon\""
    alias catt="bat --theme \"DarkNeon\""
fi

[[ -f ~/.local/bin/extract ]] && alias ex=extract
[[ -f ~/.local/bin/archive ]] && alias ar=archive

###############################################################################
# Path
###############################################################################

# fucntion to add folders to the end of $PATH
addToPATH() {
    if [[ ! :$PATH: == *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# Make sure ~/.local/bin and /usr/local/bin are in $PATH.
addToPATH "/usr/local/bin"
addToPATH "$HOME/.local/bin"

addToPATH "$N_PREFIX/bin" # n-insall for node versions
addToPATH "$CARGO/bin" # rust btw
addToPATH "$GOROOT/bin" # golang
addToPATH "$GOPATH/bin" # also golang
addToPATH "$HOME/.juliaup/bin" # julia

# Load aliases from .bash_aliases or .zsh_aliases if they exist
if [[ -f ~/.zsh_aliases ]]; then
    . ~/.zsh_aliases
elif [[ -f ~/.bash_aliases ]]; then
    . ~/.bash_aliases
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

###############################################################################
# Plugins
###############################################################################

# Enable zap
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

# Load the theme.
source "$ZDOTDIR/plugins/colors/spaceship.zsh"
plug "spaceship-prompt/spaceship-prompt"
# plug "zap-zsh/zap-prompt"

# Git aliases (from oh-my-zsh, modified)
plug "$HOME/.config/zsh/plugins/git-aliases/git-aliases.plugin.zsh"

# Jump around directories
# Alternative: https://github.com/ajeetdsouza/zoxide
plug "rupa/z"

# Autosuggestions
plug "zsh-users/zsh-autosuggestions"

# Syntax highlighting (should be last one)
plug "zsh-users/zsh-syntax-highlighting"
