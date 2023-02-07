# all:
# 	@# Create required folders
# 	@echo "Making sure ~/.local/bin and ~/.config exist"
# 	mkdir -p ~/.local/bin ~/.config
# 	@# Usefull tools
# 	@echo "Installing some usefull programms..."
# 	@# stow to symlink files, xclip as a clipboard tool, 7zip for extracting archives
# 	sudo apt-get install -y curl stow ripgrep fzf htop btop tree xclip p7zip-full p7zip-rar

# TODO: Maybe use paru since no more need for sudo
INSTALL = sudo pacman -S --noconfirm --needed

all:
	@echo "hello from arch.mk"

help: ## print this help menu
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

vimdir:
	@echo "Creating directory for undofiles for vim..."
	@mkdir -p ~/.vim/undodir
	@echo "Done"

nvimdir:
	@echo "Creating directory for undofiles for nvim..."
	@mkdir -p ~/.nvim/undodir
	@echo "Done"

fonts:
	@echo "Installing fonts..."
	@mkdir -p ~/.local/share/fonts/
	@cp -r ~/.dotfiles/fonts/* ~/.local/share/fonts/
	@echo "Done"

wallpapers:
	@echo "Installing wallpapers..."
	@mkdir -p ~/personal/media/
	@git clone https://github.com/Mach-OS/wallpapers ~/personal/media/wallpapers
	@echo "Done"

###################################################################################################
# Software
###################################################################################################

paru: ## Install paru (the AUR helper)
	@echo "==================================================================="
	@if [ -f "/usr/bin/paru" ]; then echo "[paru]: Already installed";\
		else echo "Installing paru..." && $(INSTALL) base-devel &&\
		git clone https://aur.archlinux.org/paru.git ~/paru && cd ~/paru &&\
		makepkg -si && rm -rf ~/paru && echo "Done"; fi

nvim_build_reqs:
	@# Neovim prerequisites
	@echo "==================================================================="
	@echo "Installing Neovim build prerequisites..."
	@$(INSTALL) base-devel cmake unzip ninja tree-sitter curl

nvim: nvimdir nvim_build_reqs ## Install neovim by building it from github
	@# Install neovim by building it
	@echo "==================================================================="
	@if [ -f "/usr/local/bin/nvim" ]; then echo "[nvim]: Already installed";\
		else echo "Installing Neovim..." &&\
		git clone https://github.com/neovim/neovim ~/neovim && cd ~/neovim/ &&\
		make CMAKE_BUILD_TYPE=Release && sudo make install && rm -rf ~/neovim &&\
		echo "Done"; fi

uninstall_nvim:
	@if [ -f "/usr/local/bin/nvim" ]; then echo "Uninstalling Neovim..." &&\
		sudo rm -f /usr/local/bin/nvim && sudo rm -rf /usr/local/share/nvim/ &&\
		echo "Done"; fi

purge_nvim: uninstall_nvim
	@echo "Uninstalling Neovim Leftovers..."
	rm -rf ~/.config/nvim
	rm -rf ~/.local/share/nvim
	rm -rf ~/.cache/nvim
	@echo "Done"

n: ## Install n, the node version manager
	@echo "==================================================================="
	@# With second if check if N_PREFIX is already defined in bashrc/zshrc
	@if [ ! -d ~/.n ]; then echo "Installing n (nodejs version manager) with latest stable node and npm versions..." &&\
		if [ -z $N_PREFIX ]; then curl -L https://git.io/n-install | N_PREFIX=~/.n bash; else curl -L https://git.io/n-install | N_PREFIX=~/.n bash -s -- -y -n; fi &&\
		echo "Done"; else echo "[n]: Already installed"; fi

uninstall_n:
	n-uninstall

export_node_modules:
	@echo "Exporting global node modules to .npm_modules"
	npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > .npm_modules

import_node_modules:
	@if [ -f .npm_modules ]; then echo "Installing global node modules from .npm_modules" &&\
		xargs npm install --global < .npm_modules; else echo "[node modules]: .npm_modules file not found"; fi

typescript:
	@echo "==================================================================="
	@# Install tsc and ts-node
	@npm install -g typescript ts-node

.PHONY: all help vimdir nvimdir fonts wallpapers paru nvim_build_reqs nvim uninstall_nvim \
	purge_nvim n uninstall_n export_node_modules import_node_modules typescript
