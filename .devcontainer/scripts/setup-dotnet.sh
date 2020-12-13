# Install .NET SDK
# we use APT over curl, if you want nightlies, make a branch.
# get Microsoft Repos
wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb 
dpkg -i packages-microsoft-prod.deb 
apt-get update 
apt-get -y install --no-install-recommends dotnet-sdk-3.1 dotnet-sdk-5.0 powershell
rm packages-microsoft-prod.deb
