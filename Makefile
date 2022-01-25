.PHONY: all help musthave build_reqs dirs vimdir nvimdir font_install tmux zsh nvim uninstall_nvim nodejs install sinstall finstall alacritty alacritty_build_reqs linux_install

all: dirs
	@echo "For help run 'make help'"

help:
	@# @echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\033[36m\1\\033[m:\2/' | column -c2 -t -s :)"
	@echo "WIP..."

musthave:
	@# Usefull tools
	@echo "Installing some usefull programms..."
	sudo apt-get install -y stow ripgrep fzf htop

build_reqs:
	@# Neovim prerequisites
	@echo "========================================"
	@echo "Installing Neovim build prerequisites..."
	sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

dirs:
	@echo "Creating directories for undofiles for vim/neovim..."
	mkdir -p ~/.nvim/undodir
	mkdir -p ~/.vim/undodir
	@echo "Done"

vimdir:
	@echo "Creating directory for undofiles for vim..."
	mkdir -p ~/.vim/undodir
	@echo "Done"

nvimdir:
	@echo "Creating directory for undofiles for vim..."
	mkdir -p ~/.vim/undodir
	@echo "Done"

font_install:
	mkdir -p ~/.local/share/fonts/
	cp ~/.dotfiles/fonts/* ~/.local/share/fonts/

tmux:
	@echo "Installing Tmux"
	sudo apt install tmux -y

zsh:
	@# TODO: the way to check if zsh is selected is not consistent, gotta rethink
	@# Installing zsh
	@if [ ! -f /usr/bin/zsh ]; then echo "Installing Zsh..." && sudo apt install zsh -y && echo "Done"; else echo "[zsh]: Zsh is already installed"; fi
	@# Check if zsh is the shell, change if not
	@# Problem: after installing zsh it needs a restart to detect $(which zsh)
	@# Solution: hardcode zsh location, but it won't work on Mac
	@if [ "$$(tail /etc/passwd -n1 | awk -F : '{print $$NF}')" != "/usr/bin/zsh" ]; then\
		echo "Changing shell to ZSH" && chsh -s /usr/bin/zsh &&\
		echo "Successfully switched to ZSH. Don't forget to restart your terminal."; fi
	@# Installing oh-my-zsh
	@if [ ! -d ~/.oh-my-zsh ]; then echo "Installing Oh-My-Zsh..." &&\
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc &&\
		echo "Done"; else echo "[oh-my-zsh]: Oh-My-Zsh is already installed"; fi

nvim: build_reqs
	@echo "Installing Neovim..."
	@if [ -f "/usr/local/bin/nvim" ]; then echo "[nvim]: Neovim already installed";\
		else git clone https://github.com/neovim/neovim ~/neovim && cd ~/neovim/ && make -j4 && sudo make install; fi

uninstall_nvim:
	@echo "Uninstalling Neovim..."
	sudo rm /usr/local/bin/nvim
	sudo rm -r /usr/local/share/nvim/
	@echo "Done"

nodejs:
	@if [ ! -d ~/.n ]; then echo "Installing n, nodejs version manager with latest stable node and npm versions..." &&\
		curl -L https://git.io/n-install | N_PREFIX=~/.n bash -s -- -y &&\
		echo "Done"; else echo "[nodejs]: Latest node and npm versions are already installed"; fi

install: musthave dirs font_install tmux zsh nvim nodejs
	./install

sinstall: musthave vimdir tmux
	./install --small

finstall: musthave dirs font_install tmux zsh nvim nodejs
	./install --full

alacritty_build_reqs:
	@# Installling rustup.rs
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	rustup override set stable
	rustup update stable
	@# Installing dependencies
	sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

alacritty: alacritty_build_reqs
	@echo "Downloading Alacritty..."
	git clone https://github.com/alacritty/alacritty.git && cd alacritty
	@echo "Building Alacritty..."
	cargo build --release
	@# Post Build
	@# Terminfo
	sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
	@# Copy the binary to $PATH
	sudo cp target/release/alacritty /usr/local/bin
	sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
	@# Add Manual Page
	sudo mkdir -p /usr/local/share/man/man1
	gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
	gzip -c extra/alacritty-msg.man | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
linux_install: alacritty
	@# Installing Linux only usefull tools: feh for images
	sudo apt install -y feh