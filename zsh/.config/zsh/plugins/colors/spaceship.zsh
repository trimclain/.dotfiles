###############################################################################
# spaceship-prompt settings
###############################################################################

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
    # vi_mode       # Vi-mode indicator
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

