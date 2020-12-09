# Install User - create dotfiles and prompts
 # Do not run this as root or it won't work as expected 

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# User run command path, tilde ~ won't work for this.
USER_RC_PATH="/home/${USERNAME}"

RC_SNIPPET="$(cat << EOF
export USER=vscode

export PATH=\$PATH:\$HOME/.local/bin
EOF
)"

# Create or update a non-root user to match UID/GID.
make_user() {
    useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME
    groupadd --gid $USER_GID $USERNAME
    usermod --gid $USER_GID $USERNAME
    usermod --uid $USER_UID $USERNAME
}

# Add add sudo support for non-root user
if [ "${USERNAME}" != "root" ] && [ "${EXISTING_NON_ROOT_USER}" != "${USERNAME}" ]; then
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
    chmod 0440 /etc/sudoers.d/$USERNAME
    EXISTING_NON_ROOT_USER="${USERNAME}"
fi


# code shim, it fallbacks to code-insiders if code is not available
cat << 'EOF' > /usr/local/bin/code
#!/bin/sh

get_in_path_except_current() {
  which -a "$1" | grep -v "$0" | head -1
}

code="$(get_in_path_except_current code)"

if [ -n "$code" ]; then
  exec "$code" "$@"
elif [ "$(command -v code-insiders)" ]; then
  exec code-insiders "$@"
else
  echo "code or code-insiders is not installed" >&2
  exit 127
fi
EOF
chmod +x /usr/local/bin/code
}


install-omz()
{
    zshDir="/home/${USERNAME}/.oh-my-zsh"
    if $(ls $(zshDir)) != ""
        ZSH=${ZSH:-${zshDir}}
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
        sed -i -e 's/ZSH_THEME=.*/ZSH_THEME="'${OH_MY_THEME}'"/g' ${USER_RC_FILE}
    else
        echo "oh-my-zsh already there."
    fi
}

if [ "${RC_SNIPPET_ALREADY_ADDED}" != "true" ]; then
    echo "${RC_SNIPPET}" >> /etc/bash.bashrc
    RC_SNIPPET_ALREADY_ADDED="true"
fi

# Install and configure zsh and Oh My Zsh!
apt-get-update-if-needed
apt-get install -y zsh
if [ "${ZSH_ALREADY_INSTALLED}" != "true" ]; then
    echo "${RC_SNIPPET}" >> /etc/zsh/zshrc
    ZSH_ALREADY_INSTALLED="true"
fi

install-omz

    # install the dotnet tools we know we want
    # see dotnet-tools.json
    # && dotnet tool restore
    #
    # these go here:
    # Global tools are installed in the following directories by default when you specify the -g or --global option:
    # Linux/macOS:  $HOME/.dotnet/tools
    
    # add scripting
    dotnet tool install -g dotnet-script
    # add API tooling
    dotnet tool install -g APIPort
    # add conversion utility for Dotnet Framework conversion
    /bin/su -c sh dotnet tool install -g try-convert - ${USERNAME}
    # add Project Tye
    /bin/su -c sh dotnet tool install -g Microsoft.Tye --version "0.6.0-*" --add-source https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet5/nuget/v3/index.json - ${USERNAME}

fonts:
    # # clone patched powerline fonts
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
fi
