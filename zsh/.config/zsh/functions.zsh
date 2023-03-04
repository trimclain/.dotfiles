# Function to source files if they exist
function zsh_add_file() {
    [[ -f "$1" ]] && source "$1" && return 0
    [[ -f "$ZDOTDIR/$1" ]] && source "$ZDOTDIR/$1" && return 0
    return 1
}

# Function to add plugins
function plug() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    PLUGIN_DIR=$XDG_DATA_HOME/zsh/plugins/$PLUGIN_NAME
    LOCAL_PLUGIN_DIR=$ZDOTDIR/plugins/$PLUGIN_NAME
    # If found in $ZDOTDIR/plugins, just source the plugin
    if [[ -d "$LOCAL_PLUGIN_DIR" ]]; then
        zsh_add_file "$LOCAL_PLUGIN_DIR/$PLUGIN_NAME.plugin.zsh" || \
            zsh_add_file "$LOCAL_PLUGIN_DIR/$PLUGIN_NAME.zsh" || \
            echo "Error: couldn't source $PLUGIN_NAME"
    elif [[ -d "$PLUGIN_DIR" ]]; then
        # If given a second argument, use it as a filename to source
        if [[ -n $2 ]]; then
            zsh_add_file "$PLUGIN_DIR/$2.plugin.zsh" || \
                zsh_add_file "$PLUGIN_DIR/$2.zsh" || \
                zsh_add_file "$PLUGIN_DIR/$PLUGIN_NAME.zsh-theme" || \
                echo "Error: couldn't source $PLUGIN_NAME"
        else
            zsh_add_file "$PLUGIN_DIR/$PLUGIN_NAME.plugin.zsh" || \
                zsh_add_file "$PLUGIN_DIR/$PLUGIN_NAME.zsh" || \
                zsh_add_file "$PLUGIN_DIR/$PLUGIN_NAME.zsh-theme" || \
                echo "Error: couldn't source $PLUGIN_NAME"
        fi
    else
        echo -n "Installing $PLUGIN_NAME..."
        git clone "https://github.com/$1.git" "$PLUGIN_DIR" &> /dev/null
        echo "Done"
    fi
}
