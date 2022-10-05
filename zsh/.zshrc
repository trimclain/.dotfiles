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

VIM="nvim"

# Path to my dotfiles
export DOTFILES="$HOME/.dotfiles"

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

# To keep zsh config in ~/.config/zsh
# export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

###############################################################################
# Plugin Manager
source /$DOTFILES/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git

# Syntax highlighting bundle and autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

# Load the theme.
# antigen theme robbyrussell
antigen theme spaceship-prompt/spaceship-prompt

# Tell Antigen that you're done.
antigen apply
###############################################################################

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

###############################################################################
# spaceship-prompt settings
###############################################################################
# TODO: move to a separate file
#
# Prefix
if [ $IS_SSH ]; then
    # Prompt replacement symbols
    export SPACESHIP_PROMPT_DEFAULT_PREFIX='/ '
    export SPACESHIP_CHAR_SYMBOL='-> '

    # Git replacement symbols
    export SPACESHIP_GIT_SYMBOL='git:'

    export SPACESHIP_GIT_STATUS_UNTRACKED='?'
    export SPACESHIP_GIT_STATUS_AHEAD='^'
    export SPACESHIP_GIT_STATUS_BEHIND='v'
    export SPACESHIP_GIT_STATUS_DIVERGED='<diverged>'

    # Pyenv
    SPACESHIP_PYENV_SYMBOL="pyenv:"
else
    export SPACESHIP_CHAR_SYMBOL='❯ '
fi

# Time
export SPACESHIP_TIME_SHOW=true

# Number of folders of cwd to show in prompt, 0 to show all
export SPACESHIP_DIR_TRUNC=1 # default 3


SPACESHIP_PROMPT_ORDER=(
    user          # Username section
    dir           # Current directory section
    host          # Hostname section
    git           # Git section (git_branch + git_status)
    # hg            # Mercurial section (hg_branch  + hg_status)
    # package       # Package version
    # gradle        # Gradle section
    # maven         # Maven section
    # node          # Node.js section
    # ruby          # Ruby section
    # elixir        # Elixir section
    # xcode         # Xcode section
    # swift         # Swift section
    # golang        # Go section
    # php           # PHP section
    # rust          # Rust section
    # haskell       # Haskell Stack section
    # julia         # Julia section
    docker        # Docker section
    # aws           # Amazon Web Services section
    # gcloud        # Google Cloud Platform section
    venv          # virtualenv section
    # conda         # conda virtualenv section
    # pyenv         # Pyenv section
    # dotnet        # .NET section
    # ember         # Ember.js section
    # kubectl       # Kubectl context section
    # terraform     # Terraform workspace section
    # ibmcloud      # IBM Cloud section
    exec_time     # Execution time
    line_sep      # Line break
    # battery       # Battery level and status
    vi_mode       # Vi-mode indicator
    # jobs          # Background jobs indicator
    exit_code     # Exit code section
    char          # Prompt character
)

# Hacks to get RPOMPT on top line :)
function spaceship_rprompt_prefix() {
    echo -n '%{'$'\e[1A''%}'
}

function spaceship_rprompt_suffix() {
    echo -n '%{'$'\e[1B''%}'
}

# RPROMPT
SPACESHIP_RPROMPT_ORDER=(
    rprompt_prefix
    time # Time stamps section
    rprompt_suffix
)

###############################################################################

# ---> Keybinds <---
bindkey '^ ' autosuggest-accept
# edit dotfiles
bindkey -s ^q "^utmux-sessionizer $DOTFILES\n"
# start tmux-sessionizer
bindkey -s ^t "^utmux-sessionizer\n"
# get help from cht.sh in tmux
bindkey -s ^h "^utmux-cht.sh\n"

bindkey -s ^b "^uchange-wallpaper\n"

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

# Disable all ERROR sounds
unsetopt BEEP

# ---> Aliases <---

unalias g # remove this alias for g-install, coz cmon, who is lazy enough not to type git?!!

alias szrc="exec zsh"
# alias szrc="source ~/.zshrc" doesn't work with antigen \_/
alias icat="kitty +kitten icat" # preview images in kitty

alias vim="$VIM"
alias ebrc="$VIM $DOTFILES/bash/.bashrc --cmd \"cd $DOTFILES/bash/\""
alias ezrc="$VIM $DOTFILES/zsh/.zshrc --cmd \"cd $DOTFILES/zsh/\""
alias evrc="$VIM $DOTFILES/vim/.vimrc --cmd \"cd $DOTFILES/vim\""
alias enrc="$VIM $DOTFILES/nvim/.config/nvim/init.lua --cmd \"cd $DOTFILES/nvim/.config/nvim/\""

alias py="python3"

alias la="ls -A --group-directories-first"
alias l="ls -lhA --group-directories-first"

# Extract Stuff
# INFO: `7z x $1` can be used for everything
extract() {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1        ;;
             *.bz2)       bunzip2 $1        ;;
             *.rar)       7z x $1           ;;
             *.gz)        gunzip $1         ;;
             *.tar)       tar xf $1         ;;
             *.tbz2)      tar xjf $1        ;;
             *.tgz)       tar xzf $1        ;;
             *.zip)       unzip $1          ;;
             *.Z)         uncompress $1     ;;
             *.7z)        7z x $1           ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
             # *)           if [ -f /usr/bin/7z ]; then 7z x $1; else echo "'$1' cannot be extracted via extract()"; fi;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

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
