INSTALL = sudo pacman -S --noconfirm --needed
FLATINSTALL = flatpak install -y --or-update

all:
	@# Make sure these folders exist
	@mkdir -p ~/.local/bin ~/.config
	@echo "Installing some basic tools..."
	@$(INSTALL) curl wget stow ripgrep fzf htop tree p7zip

help: ## print this help menu
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

vimdir:
	@echo "Creating directory for undofiles for vim..."
	@mkdir -p ~/.vim/undodir
	@echo "Done"

# TODO: In case I'm missing icons, check https://unix.stackexchange.com/a/685714
fonts:
	@echo "Installing fonts to ~/.local/share/fonts/"
	@mkdir -p ~/.local/share/fonts/
	@cp -r ~/.dotfiles/fonts/* ~/.local/share/fonts/
	@echo "Done"

del_fonts:
	@echo "Deleting fonts from ~/.local/share/fonts/"
	@rm -r ~/.local/share/fonts/

clean_fonts: del_fonts fonts

wallpapers:
	@echo "Installing wallpapers..."
	@mkdir -p ~/personal/media/
	@git clone https://github.com/Mach-OS/wallpapers ~/personal/media/wallpapers
	@echo "Done"

###################################################################################################
# Languages
###################################################################################################

# TODO: switch to pyenv for version control
# TODO: switch to virtualenv (venv comes built-in, but has less features)
python: ## Install python3, pip
	@echo "Installing python3 with pip"
	@$(INSTALL) python python-pip

# TODO: rust, go (add to .PHONY)
rust: ## Install rustup, the rust version manager
	@$(INSTALL) rustup

g: ## Install g, the go version manager
	@$(INSTALL) go

n: ## Install n, the node version manager
	@# With second if check if N_PREFIX is already defined in bashrc/zshrc
	@if [ ! -d ~/.n ]; then echo "Installing n (nodejs version manager) with latest stable node and npm versions..." &&\
		if [ -z $N_PREFIX ]; then curl -L https://git.io/n-install | N_PREFIX=~/.n bash;\
		else curl -L https://git.io/n-install | N_PREFIX=~/.n bash -s -- -y -n; fi &&\
		echo "Done"; else echo "[n]: Already installed"; fi

uninstall_n:
	@n-uninstall

export_node_modules:
	@echo "Exporting global node modules to .npm_modules"
	npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > .npm_modules

import_node_modules:
	@if [ -f .npm_modules ]; then echo "Installing global node modules from .npm_modules" &&\
		xargs npm install --global < .npm_modules; else echo "[node modules]: .npm_modules file not found"; fi

typescript:
	@# Install tsc and ts-node
	@npm install -g typescript ts-node

###################################################################################################
# Software
###################################################################################################

paru: ## Install paru (the AUR helper)
	@if command -v paru &> /dev/null; then echo "[paru]: Already installed";\
		else echo "Installing paru..." && $(INSTALL) base-devel &&\
		git clone https://aur.archlinux.org/paru.git ~/paru && cd ~/paru &&\
		makepkg -si && rm -rf ~/paru && echo "Done"; fi

flatpak: ## Install flatpak
	@$(INSTALL) flatpak

#========================================= Neovim =================================================
nvim_reqs:
	@# Things my neovim needs
	@echo "Installing things for Neovim..."
	@# Need yad or zenity for the color picker plugin, xclip for clipboard+
	@$(INSTALL) yad xclip
	@# Install what :checkhealth recommends
	@# Need pynvim for Bracey
	@pip install pynvim
	@npm install -g neovim

nvim_build_reqs:
	@# Neovim build prerequisites
	@echo "Installing Neovim build prerequisites..."
	@$(INSTALL) base-devel cmake unzip ninja tree-sitter curl

nvim: ## Install neovim by building it from source
	@if command -v nvim > /dev/null; then echo "[nvim]: Already installed";\
		else make nvim_build_reqs && echo "Installing Neovim..." &&\
		git clone https://github.com/neovim/neovim ~/neovim && pushd ~/neovim/ &&\
		make CMAKE_BUILD_TYPE=Release && sudo make install && popd && rm -rf ~/neovim &&\
		make nvim_reqs && echo "Done"; fi

uninstall_nvim:
	@if command -v nvim > /dev/null; then echo "Uninstalling Neovim..." &&\
		sudo rm -f /usr/local/bin/nvim && sudo rm -rf /usr/local/share/nvim/ &&\
		echo "Done"; fi

purge_nvim: uninstall_nvim
	@echo "Uninstalling Neovim Leftovers..."
	@rm -rf ~/.config/nvim
	@rm -rf ~/.local/share/nvim && rm -rf ~/.local/state/nvim && rm -rf ~/.cache/nvim
	@echo "Done"

#========================================== Zsh ===================================================
zsh: ## Install zsh
	@if command -v zsh > /dev/null; then echo "[zsh]: Already installed";\
		else echo "Installing Zsh..." && $(INSTALL) zsh && echo "Done" && make zap; fi
	@# Check if zsh is the shell, change if not
	@# Problem: after installing zsh it needs a restart to detect $(which zsh)
	@# Solution: hardcode zsh location, but it won't work on Mac
	@# TODO: why is one $ ok for [[]] but not ok anywhere else?
	@if [[ -z "$ZSH_VERSION" ]]; then echo "Changing shell to ZSH" && chsh -s /usr/bin/zsh &&\
		echo "Successfully switched to ZSH."; else echo "[zsh]: Already in use"; fi

zap:
	@if [[ -d ~/.local/share/zap ]]; then echo "[zap-zsh]: Already installed";\
		else echo "Installing zap-zsh..." && git clone https://github.com/zap-zsh/zap ~/.local/share/zap;\
		echo "Done"; fi

#======================================== Awesome =================================================
# TODO: awesome_reqs: global_fonts, commands


#==================================================================================================
telegram: ## Install Telegram Desktop using flatpak
	@if ! command -v flatpak &> /dev/null; then echo "Error: flatpak not found";\
		else $(FLATINSTALL) flathub org.telegram.desktop; fi
#==================================================================================================

apps: ## Install btop, xscreensaver, okular, lf and pcmanfm file managers
	@$(INSTALL) btop xscreensaver okular lf pcmanfm

#==================================================================================================
# TODO:
install: ## Setup arch the way I want it
	@echo "==================================================================="
	@echo Installing everything...
	@echo "==================================================================="
	@make
	@echo "==================================================================="
#==================================================================================================

.PHONY: all help vimdir fonts del_fonts clean_fonts wallpapers\
	n uninstall_n export_node_modules import_node_modules typescript\
	paru flatpak \
	nvim_reqs nvim_build_reqs nvim uninstall_nvim purge_nvim\
	zsh zap\
	telegram apps\
	install
