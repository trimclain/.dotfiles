# DEPRECATED: I fully switched to arch

INSTALL = sudo apt-get install -y
FLATINSTALL = flatpak install -y --or-update flathub
MISEINSTALL = mise use --global

all:
	@# Make sure these folders exist
	@mkdir -p ~/.local/bin ~/.config ~/.local/share/fonts/
	@echo "Installing some basic tools..."
	$(INSTALL) build-essential bc curl wget stow ripgrep fzf fd-find ncdu htop btop tree eza bat 7zip unzip jq rsync
	@# For netstat, ifconfig and more
	@# NOTE: should probably use ss from iproute2 package (networkmanager dependency)
	$(INSTALL) net-tools

help: ## Print this help menu
	@cat $(MAKEFILE_LIST) | \
		awk ' \
		/^##/ || /^#  +/ { \
			printf "\033[95m%s\033[0m\n", substr($$0, 0) \
		}; \
		/^#=/ { \
			printf "\033[35m%s\033[0m\n", substr($$0, 0) \
		}; \
		/^[a-zA-Z_-]+:.*## .*$$/ { \
			match($$0, /^[a-zA-Z_-]+/); \
			target_name = substr($$0, RSTART, RLENGTH); \
			\
			comment_start_pos = index($$0, "## "); \
			\
			if (comment_start_pos > 0) { \
				description = substr($$0, comment_start_pos + 3); \
				printf "\033[36m%-30s\033[0m %s\n", target_name, description \
			} \
		}'

vimdir:
	@echo "Creating directory for undofiles for vim..."
	@mkdir -p ~/.vim/undodir
	@echo "Done"

getnf: ## Install the Nerd Font installer
	@if [ ! -f ~/.local/bin/getnf ]; then \
		curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash; \
	fi

maple-mono: ## Install Maple Mono fonts
	@./bin/.local/bin/install-maple-mono

###################################################################################################
#                                            Languages                                            #
###################################################################################################

mise: ## Install mise (a polyglot tool version manager) with latest node
	$(INSTALL) extrepo && \
		sudo extrepo enable mise && \
		sudo apt update && \
		$(INSTALL) mise

	$(MISEINSTALL) node@latest

python: ## Install python3, pip, venv
	$(INSTALL) python3 python3-pip python3-venv

rust: ## Install rust
	$(MISEINSTALL) rust@latest

julia: ## Install julia
	$(MISEINSTALL) julia@latest

go: ## Install go
	$(MISEINSTALL) go@latest

typescript: ## Install tsc, ts-node and pnpm
	npm install -g typescript ts-node pnpm

tectonic: ## Install tectonic, a LaTeX engine
	@if command -v tectonic > /dev/null; then \
		echo "[tectonic]: Already installed"; \
	else \
		echo "[tectonic]: Installing..."; \
		curl --proto '=https' --tlsv1.2 -fsSL https://drop-sh.fullyjustified.net | sh; \
		mv tectonic ~/.local/bin/; \
		echo "[tectonic]: Done"; \
	fi

fix_tectonic:
	@wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.17_amd64.deb && \
		sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.17_amd64.deb

uninstall_tectonic: ## Uninstall tectonic
	rm -f ~/.local/bin/tectonic


###################################################################################################
#                                             Software                                            #
###################################################################################################

flatpak: ## Install flatpak
	@if command -v flatpak &> /dev/null; then \
		echo "[flatpak]: Already installed"; \
	else \
		echo "[flatpak]: Installing..." && \
		$(INSTALL) flatpak && \
		echo "[flatpak]: Done"; \
	fi
	if ! flatpak remotes | grep -q "flathub"; then \
		echo "[flatpak]: Adding Flathub remote..." && \
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
		echo "[flatpak]: Restart your system for changes to take effect"; \
	fi

docker: ## Install docker
	@if command -v docker > /dev/null; then \
		echo "[docker]: Already installed"; \
	else \
		echo "[docker]: Installing..." && \
		$(INSTALL) docker.io docker-buildx docker-compose-v2 && \
		sudo systemctl enable docker.socket --now && \
		sudo usermod -aG docker $$USER && \
		echo "[docker]: Done"; \
		echo "[docker]: Run 'newgrp docker' or Re-sign in to use docker without sudo"; \
	fi

podman: ## Install podman (daemon-less alternative to Docker)
	$(INSTALL) podman

pm2: ## Install pm2 (daemon process manager for node.js)
	npm install --global pm2

ufw: ## Install ufw (Uncomplicated Firewall)
	$(INSTALL) ufw

yazi: ## Install yazi (file manager)
	$(MISEINSTALL) yazi@latest

#============================================= Neovim =============================================
nvim-reqs: ## Install my neovim requirements (yad, xclip, wl-clipboard, tree-sitter-cli, tectonic)
	@# Things my neovim needs
	@echo "Installing things for Neovim..."
	@# - yad (or zenity) for the color picker plugin
	@# - xclip and wl-clipboard for clipboard management
	@# - tree-sitter cli for autoinstalling parsers
	$(INSTALL) yad xclip wl-clipboard tree-sitter-cli
	@#make tectonic

nvim-build-reqs: ## Install neovim build prerequisites
	@# Neovim build prerequisites
	@echo "Installing Neovim build prerequisites..."
	@$(INSTALL) ninja-build gettext cmake curl build-essential git

nvim-dev: ## Install neovim by building it from source
	@if command -v nvim > /dev/null; then \
		echo "[nvim]: Already installed"; \
	else \
		make nvim-build-reqs && \
		echo "[nvim]: Installing from Github..." && \
		git clone --depth=1 https://github.com/neovim/neovim /tmp/neovim && \
		pushd /tmp/neovim/ && \
		make CMAKE_BUILD_TYPE=Release && \
		sudo make install && \
		popd && \
		rm -rf /tmp/neovim && \
		make nvim-reqs && \
		echo "[nvim]: Done"; \
	fi

uninstall-nvim-dev: ## Uninstall neovim that was built from source (e.g. with `make nvim-dev`)
	@if [[ -f /usr/local/bin/nvim ]]; then \
		echo "Uninstalling Neovim..." && \
		sudo rm -f /usr/local/bin/nvim && \
		sudo rm -rf /usr/local/share/nvim/ && \
		echo "Done"; \
	fi

clean-nvim: ## Uninstall neovim packages, remove state and cache files
	@echo "Uninstalling Neovim Leftovers..."
	@rm -rf ~/.local/share/nvim && rm -rf ~/.local/state/nvim && rm -rf ~/.cache/nvim
	@echo "Done"

purge-nvim: uninstall-nvim-dev clean-nvim  ## Uninstall neovim installed from source and remove all it's leftovers

neovim: ## Install neovim package
	@make nvim-reqs
	@# $(INSTALL) neovim
	$(MISEINSTALL) neovim

#============================================== Zsh ===============================================
zoxide: ## Install zoxide (a smart cd command)
	$(INSTALL) zoxide

starship: ## Install starship (customizable prompt for any shell)
	$(MISEINSTALL) starship

zsh: ## Install zsh
	@if command -v zsh > /dev/null; then \
		echo "[zsh]: Already installed"; \
	else \
		echo "[zsh]: Installing..." && \
		$(INSTALL) zsh && \
		echo "[zsh]: Done" && \
		make zap && \
		make starship && \
		make zoxide; \
	fi
	@# Check if zsh is the shell, change if not
	@if [[ -z "$$ZSH_VERSION" ]]; then \
		echo "[zsh]: Changing shell to Z shell" && \
		sudo chsh -s /bin/zsh $$USER && \
		echo "[zsh]: Successfully switched to Z shell. This might work only after reboot."; \
	else \
		echo "[zsh]: Already in use"; \
	fi

zap: ## Install zap-zsh (a zsh plugin manager)
	@if [[ -d ~/.local/share/zap ]]; then \
		echo "[zap-zsh]: Already installed"; \
	else \
		echo "[zap-zsh]: Installing..." && \
		git clone https://github.com/zap-zsh/zap ~/.local/share/zap; \
		echo "[zap-zsh]: Done"; \
	fi

#========================================= Window Manager =========================================
i3: ## Install i3wm
	$(INSTALL) i3

awesome: ## Install AwesomeWM with all dependencies
	@# Install
	@# - awesome
	@# - suckless-tools (dmenu and slock)
	@# - rofi (better dmenu)
	$(INSTALL) awesome suckless-tools xss-lock picom rofi

#============================================ Terminal ============================================
alacritty: ## Install Alacritty
	$(INSTALL) alacritty

kitty: ## Install Kitty
	@# imagemagick is required to display uncommon image formats in kitty
	$(INSTALL) imagemagick kitty

#============================================ Browser =============================================
brave: ## Install Brave Browser
	$(FLATINSTALL) com.brave.Browser

chrome: ## Install Google Chrome Browser
	$(FLATINSTALL) com.google.Chrome

chromium: ## Install Chromium Browser
	$(FLATINSTALL) org.chromium.Chromium

zen: ## Install Zen Browser
	$(FLATINSTALL) app.zen_browser.zen

vivaldi: ## Install Vivaldi Browser
	$(FLATINSTALL) com.vivaldi.Vivaldi

#======================================== Remote Desktop ==========================================
anydesk: ## Install AnyDesk
	$(FLATINSTALL) com.anydesk.Anydesk

rustdesk: ## Install RustDesk
	$(FLATINSTALL) com.rustdesk.RustDesk

#==================================================================================================

telegram: ## Install Telegram Desktop
	$(FLATINSTALL) org.telegram.desktop

discord: ## Install Discord
	$(FLATINSTALL) com.discordapp.Discord

spotify: ## Install Spotify
	$(FLATINSTALL) com.spotify.Client

obs: ## Install OBS Studio
	@# Flatpak version is the only official version
	$(FLATINSTALL) com.obsproject.Studio

# I have to sometimes
vscode: ## Install VSCode (VSCodium)
	$(FLATINSTALL) com.vscodium.codium

office: ## Install LibreOffice
	$(INSTALL) libreoffice

gimp: ## Install GIMP (GNU Image Manipulation Program)
	@$(FLATINSTALL) org.gimp.GIMP

kdenlive: ## Install Kdenlive (Video Editor)
	$(FLATINSTALL) org.kde.kdenlive

inkscape: ## Install Inkscape (Vector Graphics Editor)
	@$(FLATINSTALL) org.inkscape.Inkscape

audacity: ## Install Audacity (Audio Editor)
	@$(FLATINSTALL) org.audacityteam.Audacity

localsend: ## Install LocalSend (Open Source AirDrop)
	$(FLATINSTALL) org.localsend.localsend_app

tailscale: ## Install Tailscale
	@if command -v tailscale > /dev/null; then \
		echo "[tailscale]: Already installed"; \
	else \
		echo "[tailscale]: Installing..." && \
		curl -fsSL https://tailscale.com/install.sh | sh && \
		sudo tailscale set --operator=$$USER && \
		mkdir -p ~/.local/share/bash-completion/completions && \
		tailscale completion bash > ~/.local/share/bash-completion/completions/tailscale && \
		echo "[tailscale]: Done"; \
	fi

#=============================================== AI ===============================================
ollama: ## Install Ollama (To run LLMs locally)
	$(MISEINSTALL) ollama@latest

#============================================= Study ==============================================
anki: ## Install Anki
	$(eval ANKI_VERSION := $(shell curl -fsSL https://github.com/ankitects/anki/releases/latest | grep "<title>Release " | awk '{print $$2}'))
	@echo "Installing Anki..."
	@# Requirements
	$(INSTALL) libxcb-xinerama0
	@# Install the latest version
	curl -LO https://github.com/ankitects/anki/releases/download/$(ANKI_VERSION)/anki-launcher.tar.zst
	@# Unpack it
	tar xaf ./anki-launcher.tar.zst
	@# Run the installation script
	cd ./anki-launcher && sudo ./install.sh
	@# Delete the folder and the archive
	rm -rf ./anki-launcher ./anki-launcher.tar.zst

uninstall-anki: # Uninstall Anki
	cd /usr/local/share/anki/ && sudo ./uninstall.sh

blanket: ## Install Blanket (white noise app)
	$(INSTALL) blanket

#==================================================================================================

file-manager: ## Install pcmanfm and dolphin
	@# Options:
	@# - krusader - Total Commander for linux (vsplit by default)
	@# - thunar - xfce file manager
	@# pcmanfm is lighweight, dolphin helps with MTP Android file transfer
	$(INSTALL) pcmanfm dolphin

image-viewer: ## Install feh, sxiv and nomacs
	$(INSTALL) feh sxiv
	$(FLATINSTALL) org.nomacs.ImageLounge

pdf-viewer: ## Install zathura and okular
	@# Options:
	@# - Zathura (vith vim bindings)
	@# - Okular (from KDE)
	@# - Papers (from Gnome)
	@# - Atril (Evince fork)
	@# - Sioyek (PDF Viewer with focus on research papers - similar to zathura)
	$(INSTALL) zathura okular

sysmon: ## Install btop and gnome-system-monitor
	$(INSTALL) btop gnome-system-monitor

apps: ## Install flameshot, ncdu, mpv, file-manager, image-viewer, sysmon, pdf-viewer
	@echo "==================================================================="
	@echo "Installing apps..."
	@echo "==================================================================="
	$(INSTALL) flameshot ncdu mpv
	@make file-manager
	@make image-viewer
	@make sysmon
	@make pdf-viewer

#==================================================================================================
server: ## Setup a Linux Server
	@echo "==================================================================="
	@echo "Starting Ubuntu Server Setup..."
	@echo "==================================================================="
	@make all
	@make vimdir
	$(INSTALL) tmux
	@make mise
	@# I love to mail on crontab errors
	$(INSTALL) mailutils neofetch
	./install --server
	@echo "========================== DONE ==================================="

install: zsh mise neovim ## install tmux, zsh, neovim, mise, nodejs and my configs for neovim, tmux and zsh
	$(INSTALL) tmux
	./install --normal

sinstall: vimdir ## install tmux and my config for bash, tmux and vim
	$(INSTALL) tmux
	./install --small

finstall: vimdir zsh mise neovim go rust ## combine "make sinstall" and "make install"
	$(INSTALL) tmux
	./install --full

#==================================================================================================
# INFO: Install .deb app with `sudo dpkg -i filename.deb` and `sudo apt -f install`
linux_install: zsh ## Setup Debian-based Linux after new installation
	@echo "==================================================================="
	@echo "Setting up fresh Linux System..."
	@echo "==================================================================="
	@# symlink my configs
	@./install --linux
	@# programming languages
	@make python
	@make rust
	@make go
	@# must have
	@make flatpak
	@make mise
	@# window manager
	@make awesome
	@# terminal
	@make kitty
	@make alacritty
	@# fonts
	@make maple-mono
	@make getnf
	@getnf -i JetBrainsMono,IBMPlexMono,CascadiaCode,GeistMono
	@# shell
	@make zsh
	$(INSTALL) tmux
	@# editor
	@make nvim-dev
	@echo "========================== DONE ==================================="

#==================================================================================================

.PHONY: all help vimdir getnf maple-mono \
	mise python rust julia go typescript tectonic fix_tectonic uninstall_tectonic\
	flatpak docker podman pm2 ufw yazi\
	nvim-reqs nvim_build_reqs nvim-dev uninstall-nvim-dev clean_nvim purge_nvim neovim\
	zoxide starship zsh zap\
	i3 awesome\
	alacritty kitty\
	brave chrome chromium zen vivaldi\
	anydesk rustdesk\
	telegram discord spotify obs vscode office gimp kdenlive inkscape audacity localsend tailscale\
	ollama\
	anki uninstall_anki blanket\
	file-manager image-viewer pdf-viewer sysmon apps\
	server install sinstall finstall \
	linux_install
