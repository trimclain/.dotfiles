INSTALL = pkg install -y

all: ## Run inititial setup
	@# Make sure these folders exist
	@mkdir -p ~/.local/bin ~/.config
	@echo "Installing some basic tools..."
	termux-change-repo && pkg update && pkg upgrade -y
	$(INSTALL) curl git tree which vim rsync fzf stow
	@# install ssh tools and autocompletion for scp
	$(INSTALL) openssh bash-completion
	@# enable sshd to autostart
	@#sv-enable sshd
	$(INSTALL) yazi
	$(INSTALL) nmap
	@# for nslookup
	@#pkg install dnsutils
	@# setup storage access
	@make storage

help: ## Print help for targets with comments
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

storage: ## Set up storage
	termux-setup-storage

fonts: ## Install getnf and maple-mono
	if ! command -v getnf > /dev/null; then \
		curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash; \
	fi
	./bin/.local/bin/install-maple-mono

# Optional font folder name, supplied as: make termux-font name=JetBrainsMono
name ?=
export name

use-font: ## Choose a font for termux
	@set -eu; \
	cd "$$HOME/.local/share/fonts"; \
	folders=$$(find -L . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort); \
	if [ -n "$$name" ]; then \
		folder=$$(printf '%s\n' "$$folders" | awk 'index($$0, ENVIRON["name"]) { print; exit }'); \
	else \
		folder=$$(printf '%s\n' "$$folders" | fzf --prompt='Font folder: ') || exit 0; \
	fi; \
	[ -n "$$folder" ] || exit 0; \
	cd "$$folder"; \
	font=$$(find -L . -type f -iname '*.ttf' -printf '%P\n' \
		| sort | fzf --prompt='TTF file: ') || exit 0; \
	mkdir -p "$$HOME/.termux"; \
	cp -- "$$font" "$$HOME/.termux/font.ttf"; \
	termux-reload-settings

install: ## Symlink configs
	 ./install --termux

.PHONY: all help storage fonts use-font install
