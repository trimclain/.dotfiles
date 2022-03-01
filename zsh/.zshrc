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

# Update $PATH.
export PATH="$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH"

# Path to my oh-my-zsh installation.
# export ZSH="/home/$USERNAME/.oh-my-zsh"

# Path to my dotfiles
export DOTFILES="$HOME/.dotfiles"

# ZSH_THEME="robbyrussell"

########################### A LITTLE TOO LAGGY ################################
###########################         |          ################################
###########################         v          ################################

###############################################################################
# Plugin Manager
source /$DOTFILES/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git

# Syntax highlighting bundle and autosuggestions
# antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

# Load the theme.
antigen theme robbyrussell

# Tell Antigen that you're done.
antigen apply
###############################################################################

###########################         ^          ################################
###########################         |          ################################
########################### A LITTLE TOO LAGGY ################################

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

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

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# plugins=(git zsh-autosuggestions)

# source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Keybinds
bindkey '^ ' autosuggest-accept
bindkey -s ^q "tmux-sessionizer $DOTFILES\r"

bindkey -s ^u "Update\r"
bindkey -s ^b "change-background\r"

# Disable all ERROR sounds
unsetopt BEEP

# Aliases
alias szrc="exec zsh"
# alias szrc="source ~/.zshrc" doesn't work with antigen \_/

alias vim="$VIM"
alias ebrc="$VIM $DOTFILES/bash/.bashrc --cmd \"cd $DOTFILES/bash/\""
alias ezrc="$VIM $DOTFILES/zsh/.zshrc --cmd \"cd $DOTFILES/zsh/\""
alias evrc="$VIM $DOTFILES/vim/.vimrc --cmd \"cd $DOTFILES/vim\""
alias enrc="$VIM $DOTFILES/nvim/.config/nvim/init.vim --cmd \"cd $DOTFILES/nvim/.config/nvim/\""

alias py="python3"

alias la="ls -A --group-directories-first"
alias l="ls -lhA --group-directories-first"

# Load aliases from .bash_aliases or .zsh_aliases if they exists
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
elif [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export N_PREFIX="$HOME/.n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
PATH+=":$HOME/.cargo/bin" # Added for rustup and cargo to install Alacritty
