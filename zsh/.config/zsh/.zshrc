###############################################################################
#                                                                             #
#    ████████╗██████╗ ██╗███╗   ███╗ ██████╗██╗      █████╗ ██╗███╗   ██╗     #
#    ╚══██╔══╝██╔══██╗██║████╗ ████║██╔════╝██║     ██╔══██╗██║████╗  ██║     #
#       ██║   ██████╔╝██║██╔████╔██║██║     ██║     ███████║██║██╔██╗ ██║     #
#       ██║   ██╔══██╗██║██║╚██╔╝██║██║     ██║     ██╔══██║██║██║╚██╗██║     #
#       ██║   ██║  ██║██║██║ ╚═╝ ██║╚██████╗███████╗██║  ██║██║██║ ╚████║     #
#       ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝     #
#                                                                             #
#        Arthur McLain (trimclain)                                            #
#        mclain.it@gmail.com                                                  #
#        https://github.com/trimclain                                         #
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

# Colorscheme
# Easy to change colorscheme by changing the value of $_PROMT_THEME
# Available colorschemes: spaceship, p10k-spaceship, p10k-pure, p10k-robbyrussel, zap
_PROMT_THEME="p10k-spaceship"

# Disable XON/XOFF flow control (ctrl-s to freeze, ctrl-q to unfreeze)
# This should come before powerlevel10k instant promt feature
stty -ixon
# stty start undef stop undef

if [[ "$_PROMT_THEME" == "p10k-"* ]]; then
    # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
    # Initialization code that may require console input (password prompts, [y/n]
    # confirmations, etc.) must go above this block; everything else may go below.
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi
fi

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
# Allow comments in the interactive shell
setopt interactive_comments
# Don't kill jobs when exiting shell
setopt no_hup
# And don't warn
setopt no_check_jobs
# show us when some command didn't exit with 0
setopt print_exit_value
# move cursor to end after every completion
setopt always_to_end

# Disable highlighting on paste
zle_highlight=('paste:none')

# Completion (`man zshmodules`)
# Highlight seleceted options on <Tab>
zstyle ':completion:*' menu select
# Make completion case insensitive when using small letters
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

###############################################################################
# INFO: ANSI escape codes define how colors are displayed.

# They are structured as:
# Foreground Colors (Text): 30-37
# Background Colors: 40-47
# Bright Versions (Bold): 90-97 (Foreground), 100-107 (Background)
# Color    Foreground    Background
# Black        30            40
# Red          31            41
# Green        32            42
# Yellow       33            43
# Blue         34            44
# Magenta      35            45
# Cyan         36            46
# White        37            47

# Make ls colors work with completion
eval "$(dircolors -b)"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
###############################################################################

# Disable all error sounds
unsetopt BEEP

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
if [[ -n "$SSH_CONNECTION" ]]; then
    export EDITOR="$(which vim)"
else
    export EDITOR="$(which nvim)"
fi

export VISUAL=$EDITOR

###############################################################################
# Less
###############################################################################
export MANPAGER="nvim +Man!"
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

# Path to my dotfiles
export DOTFILES="$HOME/.dotfiles"

## History
export HISTFILE=$HOME/.zsh_history
# export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=1000
export SAVEHIST=50000
export HISTORY_IGNORE="(ls|la|l|cd|cd -|cd ..|history|vim)"
# Share history across all zsh sessions
setopt sharehistory
# If a command starts with a space, don't add it to a history
setopt hist_ignore_space
# Don't save older commands that duplicate newer ones
setopt hist_save_no_dups
# Do the same as above but also in the current session
#setopt hist_ignore_all_dups
# Don't show duplicates in history search
setopt hist_find_no_dups
# When using !! or !<number>, don't expand the command before running it
setopt nohistverify

export N_PREFIX="$HOME/.n"

export GOPATH="$HOME/.go"
# Used if g (https://github.com/stefanmaric/g) is installed (not relevant on arch)
if [[ -d "$HOME/.golang" ]]; then
    export GOROOT="$HOME/.golang"
fi

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
autoload edit-command-line;
zle -N edit-command-line
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
# [[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     history-beginning-search-backward
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     history-search-backward
# [[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   history-beginning-search-forward
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   history-search-forward
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

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

if command -v fzf > /dev/null; then
    # From /usr/share/doc/fzf/examples/key-bindings.zsh
    # CTRL-R - Paste the selected command from history into the command line
    __fzfcmd() {
        [ -n "$TMUX_PANE" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; } &&
            echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
        }
    fzf-history-widget() {
        local selected num
        setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
        selected=( $(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' |
        FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore,tab:toggle-up,btab:toggle-down $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
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

if [[ -f ~/.local/bin/pctl ]]; then
    # open dotfiles in tmux (use -s with bindkey when binding to custom command)
    bindkey -s ^q "^upctl open $DOTFILES\n"
    # start ex-tmux-sessionizer
    bindkey -s ^t "^upctl open\n"
fi

if [[ -f ~/.local/bin/tmux-chtsh ]]; then
    # get help from cht.sh in tmux on Ctrl+?
    bindkey -s ^_ "^utmux-chtsh\n"
fi
# bindkey -s ^b "^uchange-wallpaper\n"

# Use lf with ueberzugpp to switch directories and bind it to ctrl-o
if command -v lf > /dev/null; then
    lfubcd() {
        # This is a wrapper for lfub wrapper implementing lfcd functionality
        if ! command -v lf > /dev/null; then
            echo "lf: command not found"
            exit 1
        fi

        local lfub="$HOME/.config/lf/lfub"

        if [[ ! -f "$lfub" ]]; then
            echo "lfub: file not found"
            exit 1
        fi

        local tmp="$(mktemp)"

        # needed by the previewer
        [ ! -d "$HOME/.cache/lf" ] && mkdir --parents "$HOME/.cache/lf"

        # `command` is needed in case `lfcd` is aliased to `lf`
        $lfub -last-dir-path="$tmp" "$@"
        if [ -f "$tmp" ]; then
            local dir="$(cat "$tmp")"
            rm -f "$tmp"
            [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir" || return 0
        fi
    }

    bindkey -s '^o' '^ulfubcd\n'
fi

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

# add verbosity
alias cp="cp -iv" \
    mv="mv -iv" \
    rm="rm -vI"
# rsync= "rsync -ahvuP"
# mkd="mkdir -pv"

# zsh specific syntax for checking if command exists
if (( $+commands[rg] )); then
    alias grep='rg'
else
    alias grep='grep --color=auto'
fi

if (( $+commands[eza] )); then
    alias ls='eza --group-directories-first --icons=always'
    alias la='ls -a'
    alias l='ls -lha'
    alias ll='ls -lh'
    alias tree='ll --tree --level=2'
else
    alias ls="ls --color=auto --group-directories-first"
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

if (( $+commands[fdfind] )); then
    # Ubuntu...
    alias fd="fdfind"
fi

[[ -f ~/.local/bin/extract ]] && alias ex=extract
[[ -f ~/.local/bin/archive ]] && alias ar=archive

###############################################################################
# Path
###############################################################################

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
addToPATH "$HOME/.juliaup/bin" # julia

addToPATH "$HOME/.cargo/bin" # rust btw

# Used if g (https://github.com/stefanmaric/g) is installed (not relevant on arch)
if [[ -n $GOROOT ]]; then
    addToPATH "$GOROOT/bin" # golang
    addToPATH "$GOPATH/bin"
fi

# I want to use the tools mason installs outside of neovim aswell
addToPATH "$XDG_DATA_HOME/nvim/mason/bin"

# Load aliases from .bash_aliases and/or .zsh_aliases if they exist
if [[ -f ~/.zsh_aliases ]]; then
    . ~/.zsh_aliases
fi
if [[ -f ~/.bash_aliases ]]; then
    . ~/.bash_aliases
fi

# enable sdkman (jdk version manager)
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# enable zoxide
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh --cmd cd)"
fi

###############################################################################
# Plugins
###############################################################################

# Enable zap (https://github.com/zap-zsh/zap)
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

# Set Promt Colors
if [[ "$_PROMT_THEME" == "spaceship" ]]; then
    # Spaceship
    source "$ZDOTDIR/plugins/colors/spaceship.zsh"
    plug "spaceship-prompt/spaceship-prompt"
elif [[ "$_PROMT_THEME" == "p10k-spaceship" ]]; then
    # Powerlevel10k Spaceship
    source "$ZDOTDIR/plugins/colors/p10k-spaceship.zsh"
    plug "romkatv/powerlevel10k"
elif [[ "$_PROMT_THEME" == "p10k-pure" ]]; then
    # Powerlevel10k pure
    source "$ZDOTDIR/plugins/colors/p10k-pure.zsh"
    plug "romkatv/powerlevel10k"
elif [[ "$_PROMT_THEME" == "p10k-robbyrussel" ]]; then
    # Powerlevel10k robbyrussel
    source "$ZDOTDIR/plugins/colors/p10-robbyrussel.zsh"
    plug "romkatv/powerlevel10k"
elif [[ "$_PROMT_THEME" == "zap" ]]; then
    # Zap Prompt
    plug "zap-zsh/zap-prompt"
fi

# Git aliases (from oh-my-zsh, modified)
plug "$HOME/.config/zsh/plugins/git-aliases/git-aliases.plugin.zsh"

# Completion
#plug "zsh-users/zsh-completions"

# Autosuggestions
plug "zsh-users/zsh-autosuggestions"

# Syntax highlighting (should be the last one)
plug "zsh-users/zsh-syntax-highlighting"
