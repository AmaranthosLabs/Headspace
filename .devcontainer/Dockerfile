# Headspace Dockerfile
# this will run the Slipstream process in a container, 
# Slipstreams are isolated by Concept and 
# make heavy use of the Sidecar Pattern 

# repository to pull from
ARG REPO=mcr.microsoft.com/dotnet/aspnet

# (image we want from the repo: debian 10)
FROM $REPO:5.0-buster-slim-amd64

# set our envoironment variables
   # Enable correct mode for dotnet watch (only mode supported in a container)

ENV DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Debian-10

# This Dockerfile adds a non-root 'vscode' user with sudo access. However, for Linux,
# this user's GID/UID must match your local user UID/GID to avoid permission issues
# with bind mounts. Update USER_UID / USER_GID if yours is not 1000. See
# https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# get Microsoft Repos

# install utils
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt install -y --no-install-recommends \
        apt-utils curl wget sudo uidmap \
    #
    && wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && sudo dpkg -i packages-microsoft-prod.deb \
    #
    && apt-get update && apt-get install -y --no-install-recommends \        
        git git-man less libbsd0 libcurl3-gnutls libedit2 \
        libc6 libgcc1 libgssapi-krb5-2 libicu63 libssl1.1 libstdc++6 \
        liberror-perl libexpat1 libgdbm-compat4 libgdbm6 \
        libpcre2-8-0 libperl5.28 libx11-6 libx11-data \
        libxau6 libxcb1 libxdmcp6 libxext6 libxmuu1 netbase \
        openssh-client patch perl perl-modules-5.28 xauth zlib1g \
    #
    && rm -rf /var/lib/apt/lists/* \
    #
    # this requires uidmap above
    # Create a non-root user to use - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
    
#
# Install .NET SDK
# we just use APT, over curl, if you want nightlies, make a branch.'
# we need 3.1 for notebooks for now
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get install -y \
            dotnet-sdk-3.1 \
            dotnet-sdk-5.0 \
            powershell \
    # install the tools we know we want
    # see dotnet-tools.json
    # && dotnet tool restore
    #
    # these go here:
    # Global tools are installed in the following directories by default when you specify the -g or --global option:
    # Linux/macOS:  $HOME/.dotnet/tools
    # Windows:      %USERPROFILE%\.dotnet\tools
    #
    # this is the old way, we need to set the json in .config
    && dotnet tool install -g dotnet-script \
    # add API tooling
    && dotnet tool install -g APIPort \
    # add conversion utility for Dotnet Framework conversion
    && dotnet tool install -g try-convert \
    # add Project Tye
    && dotnet tool install -g Microsoft.Tye --version "0.6.0-*" --add-source https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet5/nuget/v3/index.json

