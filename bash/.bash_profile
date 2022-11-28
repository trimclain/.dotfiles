# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# If you wanna detect an interactive shell, use $PS1.
# if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then
#     # include .bashrc if it exists
#     if [ -f "$HOME/.bashrc" ]; then
#     . "$HOME/.bashrc"
#     fi
# fi
