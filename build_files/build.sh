#!/bin/bash

set -ouex pipefail

### Create root directory for hdd mount points 
mkdir /data /games
### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y syncthing #kodi kodi-inputstream-adaptive

## Install ZeroTierOne
# Setup repo
cat << EOF > /etc/yum.repos.d/zerotier.repo
[zerotier]
name=ZeroTier, Inc. RPM Release Repository
baseurl=http://download.zerotier.com/redhat/fc/22
enabled=1
gpgcheck=0
EOF

# Install Zerotier
#dnf install -y zerotier-one

# Remove Zerotier repo
rm /etc/yum.repos.d/zerotier.repo -f


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging


#### Example for enabling a System Unit File

systemctl enable podman.socket syncthing@kohega.service
