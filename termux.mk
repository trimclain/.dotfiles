INSTALL = pkg install -y

all: ## Run inititial setup
	@# Make sure these folders exist
	@mkdir -p ~/.local/bin ~/.config
	@echo "Installing some basic tools..."
	termux-change-repo && pkg update && pkg upgrade -y
	$(INSTALL) curl git which vim rsync stow
	$(INSTALL) openssh
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

# TODO:
fonts: ## Install fonts
	echo "TODO: maple"

install: ## Symlink configs
	 ./install --termux

.PHONY: all help storage fonts install
