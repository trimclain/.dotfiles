# Zap-Zsh
I have two options for a solution and I'd like a help in choosing one.
First solution is the easiest one: allow passing a second variable to plug, which would be the name of the file to source.
In example of spaceship you could just take "spaceship" as a second argument.
Second solution would be to search the $plugin_dir for all files with extensions ".plugin.zsh" and ".zsh-theme" and source them.
In case of a theme there's most likely only one file with ".zsh-theme" extension.
