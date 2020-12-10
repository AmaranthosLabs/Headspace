# Install User - create dotfiles and prompts

USERNAME = ${1:-"vscode"}
USER_UID = ${2:-"1000"}
USER_GID = ${3:-"1000"}

if [ "$(id -u)" -eq 0 ]; then
    echo -e 'Script cannot be run as root. We are setting up a non-priviledged user.'
    exit 1
else
    make-user
    install-omz
    apt-get-update-if-needed
    apt-get install -y zsh
    dotnet tool restore
    clone-powerline-fonts
    mv /tmp/dotfiles/ /home/${USERNAME}
    chown dotfiles
    cd /home/${USERNAME}/dotfiles
    make all
    cd ~
    echo "setup-user.sh done."
    exit 0
fi

# Create or update a non-root user to match UID/GID.
make-user() {
    sudo useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME
    # Add add sudo support for non-root user
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
    sudo chmod 0440 /etc/sudoers.d/$USERNAME
}

install-omz()
{
    zshDir="/home/${USERNAME}/.oh-my-zsh"
    if $(ls $(zshDir)) != ""
        ZSH=${ZSH:-${zshDir}}
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
    else
        echo "oh-my-zsh already there."
    fi
}

clone-powerline-fonts() 
{
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
}
