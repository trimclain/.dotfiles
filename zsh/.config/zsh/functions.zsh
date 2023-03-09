# Function to source files if they exist
function zsh_add_file() {
    # [[ -f "$1" ]] && source "$1" && return 0
    [[ -f "$1.plugin.zsh" ]] && source "$1.plugin.zsh" && return 0
    [[ -f "$1.zsh" ]] && source "$1.zsh" && return 0
    [[ -f "$1.zsh-theme" ]] && source "$1.zsh-theme" && return 0
    return 2
}

# Function to add plugins
function plug() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    PLUGIN_DIR=$XDG_DATA_HOME/zsh/plugins/$PLUGIN_NAME
    LOCAL_PLUGIN_DIR=$ZDOTDIR/plugins/$PLUGIN_NAME
    # Look for the plugin in local plugins ($ZDOTDIR/plugins)
    if [[ -d "$LOCAL_PLUGIN_DIR" ]]; then
        { zsh_add_file "$LOCAL_PLUGIN_DIR/$PLUGIN_NAME" && return 0 } || \
            { echo "Error: couldn't source $PLUGIN_NAME" && return 2 }
    fi
    # Install the plugin if it's not there
    if [[ ! -d "$PLUGIN_DIR" ]]; then
        echo -n "Installing $PLUGIN_NAME... "
        git clone "https://github.com/$1.git" "$PLUGIN_DIR" &> /dev/null
        echo "Done"
    fi
    # If given a second argument, use it as a filename to source
    [[ -n $2 ]] && zsh_add_file "$PLUGIN_DIR/$2" || \
        zsh_add_file "$PLUGIN_DIR/$PLUGIN_NAME" || \
        { echo "Error: couldn't source $PLUGIN_NAME" && return 2 }
}
