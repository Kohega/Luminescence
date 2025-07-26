#!/bin/bash

set -ouex pipefail

trap '[[ $BASH_COMMAND != echo* ]] && [[ $BASH_COMMAND != log* ]] && echo "+ $BASH_COMMAND"' DEBUG

log() {
  echo "=== $* ==="
}

log "Starting building"
### Create root directory for hdd mount points 
mkdir /data /games

### Install packages
log "Installing apps"
echo_group /ctx/install-packages.sh

# Install RPMs
for rpm_file in ctx/rpm/*.rpm; do
    if [ -f "$rpm_file" ]; then
        dnf5 install -y "$rpm_file"
    fi
done


log "Allow Samba on home dirs"
setsebool -P samba_enable_home_dirs=1

log "Enabling system services"
systemctl enable podman.socket syncthing@kohega.service zerotier-one.service lactd.service

log "Adding personal just recipes"
echo "import \"/usr/share/kohega/just/kohega.just\"" >>/usr/share/ublue-os/justfile

log "Adding Virtual dummy display"
echo_group /ctx/edid.sh

log "Post build cleanup"
echo_group /ctx/cleanup.sh

log "Build complete"
