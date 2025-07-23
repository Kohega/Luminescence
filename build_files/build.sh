#!/bin/bash

set -ouex pipefail

### Create root directory for hdd mount points 
mkdir /data /games

### Install packages

# Enable needed COPR repos
dnf5 -y copr enable ilyaz/LACT
dnf5 -y copr enable zliced13/YACR

# Install packages from Fedora repos & COPR
dnf5 install -y syncthing filezilla firefox firefox-langpacks lact naps2 #epson-inkjet-printer-escpr kodi kodi-inputstream-adaptive

# Add ZeroTier GPG key
curl -s https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg | tee /etc/pki/rpm-gpg/RPM-GPG-KEY-zerotier

# Add ZeroTier repository
cat << 'EOF' | tee /etc/yum.repos.d/zerotier.repo
[zerotier]
name=ZeroTier, Inc. RPM Release Repository
baseurl=http://download.zerotier.com/redhat/fc/42
enabled=1
gpgcheck=0
EOF

# Install ZeroTier
dnf install -y zerotier-one

# Remove Zerotier repo
rm /etc/yum.repos.d/zerotier.repo -f

# Eddie - Airvpn
wget https://airvpn.org/mirrors/eddie.website/download/?platform=linux&arch=x64&ui=ui&format=fedora.rpm&version=2.24.6&r=0.4094494104642836
sudo rpm -U ./eddie-ui_2.24.6_linux_x64_fedora.rpm
rm eddie-ui_2.24.6_linux_x64_fedora.rpm

# losslesscut
wget -o losslesscut.AppImage https://github.com/mifi/lossless-cut/releases/download/latest/LosslessCut.AppImage
mv losslesscut.AppImage /home/kohega/Applications/
chmod +x /home/kohega/Applications/LosslessCut.AppImage

# Allow Samba on home dirs
setsebool -P samba_enable_home_dirs=1

dnf5 -y copr disable ilyaz/LACT
dnf5 -y copr disable zliced13/YACR

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

# Remove Fedora Firefox homepage
sudo rm -f /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js

#### Example for enabling a System Unit File

systemctl enable podman.socket syncthing@kohega.service zerotier-one.service lactd.service

# Enable ZeroTier
zerotier-cli join db64858feddb6902
