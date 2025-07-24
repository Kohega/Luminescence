#!/bin/bash

set -ouex pipefail

### Create root directory for hdd mount points 
mkdir /data /games

### Install packages

# Enable needed COPR repos
dnf5 -y copr enable ilyaz/LACT
dnf5 -y copr enable zliced13/YACR

# Install packages from Fedora repos & COPR
dnf5 install -y syncthing filezilla firefox firefox-langpacks lact #kodi kodi-inputstream-adaptive

# Install RPMs
dnf5 install -y /ctx/rpm/eddie-ui_2.24.6_linux_x64_fedora.rpm
dnf5 install -y /ctx/rpm/eddie-ui_2.24.6_linux_x64_fedora.rpm
dnf5 install -y /ctx/rpm/naps2-8.2.0-linux-x64.rpm

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

# Remove repos
rm /etc/yum.repos.d/zerotier.repo -f

# Allow Samba on home dirs
setsebool -P samba_enable_home_dirs=1

dnf5 -y copr disable ilyaz/LACT
dnf5 -y copr disable zliced13/YACR

# Remove Fedora Firefox homepage
sudo rm -f /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js

#### Example for enabling a System Unit File

systemctl enable podman.socket syncthing@kohega.service zerotier-one.service lactd.service

# Enable ZeroTier
zerotier-cli join db64858feddb6902
