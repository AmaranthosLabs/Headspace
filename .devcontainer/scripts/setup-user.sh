#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Amaranthos Labs, LLC. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/amaranthoslabs/headspace/blob/main/.devcontainer/scripts/scripts.md
#
# Syntax: ./setup-user.sh [username]

# Install User - create dotfiles and prompts
export DEBIAN_FRONTEND=noninteractive

USERNAME=${1:-"vscode"}

set -e

install-omz()
{
    zshDir="/home/${USERNAME}/.oh-my-zsh"
    ZSH=${ZSH:-${zshDir}}
    THEME="powerline" 
	# clone if set \
	THEME_URL="powerline" 
	
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    #if [-z ${THEME_URL}] 
    cd /home/${USERNAME}/.oh-my-zsh/themes
    wget https://raw.githubusercontent.com/jeremyFreeAgent/oh-my-zsh-powerline-theme/master/powerline.zsh-theme
    cd /home/${USERNAME}
}

clone-powerline-fonts() 
{
    cd ~
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    echo -e "installed powerline fonts..."
    cd ..
    rm -rf fonts
}

if [ "$(id -u)" -eq 0 ]; then
    echo -e 'Script cannot be run as root. We are setting up a non-priviledged user.'
    exit 1
else
    install-omz
    clone-powerline-fonts

    #Run makefile to set links
    cd /home/${USERNAME}/dotfiles  
    make default
    cd ~

    echo "setup-user.sh done."
    exit 0
fi
