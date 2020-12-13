# Headspace Dockerfile 
# Copyright (c) Amaranthos Labs, LLC. All rights reserved.

# repository to pull from - Microsoft Dotnet 5, Asp.Net
ARG REPO=mcr.microsoft.com/dotnet/aspnet

# Image we want from the repo: debian 10 - Slim see: https://stackoverflow.com/questions/59794891/how-does-debian-differ-from-debian-slim
FROM $REPO:5.0-buster-slim-amd64

# Install needed packages and setup non-root user.
ARG SOURCE_SOCKET=/var/run/docker-host.sock
ARG TARGET_SOCKET=/var/run/docker.sock

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"
ARG INSTALL_DOTNET_PKGS="dotnet-sdk-3.1 dotnet-sdk-5.0 powershell" 

# Enable correct mode for dotnet watch (only mode supported in a container)
ENV DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Debian-10 \
    # set apt prompt removal
    DEBIAN_FRONTEND=noninteractive
    
# get Microsoft Repos and
# install utils for setup
RUN apt-get update && apt install -y --no-install-recommends \
    apt-utils rsync curl wget sudo uidmap apt-transport-https ca-certificates lsb-release gnupg2 \
    && wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && sudo dpkg -i packages-microsoft-prod.deb  \
    ### DON'T FORGET TO UPDATE
    && apt-get update

# Create a non-root user to match UID/GID and put a profile in the home folder.
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && usermod -aG sudo $USERNAME 

COPY scripts/* /tmp/scripts/
COPY dotfiles/.* /tmp/dotfiles/
COPY dotfiles/* /tmp/dotfiles/

RUN rsync -a /tmp/dotfiles/ /home/$USERNAME/dotfiles/ \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME/dotfiles 

# Setup OS 
RUN sudo /bin/bash -c /tmp/scripts/setup-os.sh "${INSTALL_DOTNET_PKGS}" "${UPGRADE_PACKAGES}"

# Use Docker to switch users so it is encapsulated correctly
USER $USERNAME

# setup preferences in the home directory (dotfiles)
RUN /tmp/scripts/setup-user.sh

# finish setting up root shell and docker access    
USER root

# Set up docker (inside this container and allow vscode user)
RUN /bin/bash -c /tmp/scripts/setup-docker.sh "${SOURCE_SOCKET}" "${TARGET_SOCKET}" 

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/scripts /tmp/dotfiles

# RUNTIME Entry
WORKDIR /home/$USERNAME

ENTRYPOINT [ "/usr/local/share/docker-init.sh"]
