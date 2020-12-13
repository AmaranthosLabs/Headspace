### Makefile to Symlink Dotfiles for the vscode user in /home/vscode
SHELL := bash

.PHONY: default
default: dotfiles dotnet-restore

.PHONY: zsh
zsh: ## Ensures zsh is setup
	THEME="powerline" \
	# clone if set \
	THEME_URL="powerline" \
	if [${THEME_URL} != ""] \
		get-theme \ 
	fi \
    ZSH=${ZSH:-/home/${USERNAME}/.oh-my-zsh} \
	curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh . --unattended \
    sed -i -e 's/ZSH_THEME=.*/ZSH_THEME="'${THEME}'"/g' ~/.zshrc \
	rm .install.sh \
    echo "installed ohmyzsh."

.PHONY: get-theme
get-theme:
	cd /home/${USERNAME}/.oh-my-zsh/themes
	wget https://raw.githubusercontent.com/jeremyFreeAgent/oh-my-zsh-powerline-theme/master/powerline.zsh-theme
	cd /home/${USERNAME}
## We are getting universal fonts that work for powerline in the os
# .PHONY: fonts
# fonts: ## Install fonts we want, we should make these modules...
# 	#this is a lengthy process, we need checks first.
# 	ifdef($(shell find $(CURDIR)/.fonts -type f);) do \
# 		#dir exists, do something
		
# 	endif

.PHONY: bin
bin: ## Installs the local user bin folder.
	# add aliases for things in bin
	for file in $(shell find $(CURDIR)/bin -type f -not -name "*-backlight" -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		sudo ln -sf $$file /usr/local/bin/$$f; \
	done

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles.
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".config" -not -name ".github" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; 

	# Gnu Privacy Guard and SSH Keys
	# gpg --list-keys || true;
	# mkdir -p $(HOME)/.gnupg
	# for file in $(shell find $(CURDIR)/.gnupg); do \
	# 	f=$$(basename $$file); \
	# 	ln -sfn $$file $(HOME)/.gnupg/$$f; \
	# done; 
	ln -snf $(CURDIR)/gitignore $(HOME)/.gitignore;
	mkdir -p $(HOME)/.config;
	ln -snf $(CURDIR)/dotnet-tools.json $(HOME)/.config/dotnet-tools.json;

	# git update-index --skip-worktree $(CURDIR)/.gitconfig;
	# cd mkdir -p $(HOME)/.config;
	# mkdir -p $(HOME)/.local/share;
	# ln -snf $(CURDIR)/.fonts $(HOME)/.local/share/fonts;
	ln -snf $(CURDIR)/.bash_profile $(HOME)/.profile;

.PHONY: dotnet-restore
dotnet-restore: ##Restore user tools
	dotnet tool restore

.PHONY: etc
etc: ## Installs the etc directory files.
	sudo mkdir -p /etc/docker/seccomp
	for file in $(shell find $(CURDIR)/etc -type f -not -name ".*.swp"); do \
		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
		sudo mkdir -p $$(dirname $$f); \
		sudo ln -f $$file $$f; \
	done

.PHONY: usr
usr: ## Installs the usr directory files.
	for file in $(shell find $(CURDIR)/usr -type f -not -name ".*.swp"); do \
		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
		sudo mkdir -p $$(dirname $$f); \
		sudo ln -f $$file $$f; \
	done

.PHONY: clean
clean: ## Remove only the links in the dotfiles folder 
	cd /home/vscode
	find -type l | while IFS= read -r lnk; do if (readlink "$lnk" | grep -q '^/home/vscode/dotfiles/'); then rm "$lnk"; fi; done


.PHONY: shellcheck
shellcheck: ## Runs the shellcheck tests on the scripts.
	docker run --rm -i $(DOCKER_FLAGS) \
		--name df-shellcheck \
		-v $(CURDIR):/usr/src:ro \
		--workdir /usr/src \
		vscode/shellcheck ./test.sh

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
