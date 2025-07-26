#!/usr/bin/bash

set ${SET_X:+-x} -eou pipefail

trap '[[ $BASH_COMMAND != echo* ]] && [[ $BASH_COMMAND != log* ]] && echo "+ $BASH_COMMAND"' DEBUG

log() {
  echo "=== $* ==="
}

log "Installing RPM packages"

log "Enable Copr repos"

COPR_REPOS=(
    ilyaz/LACT
    zliced13/YACR
)
for repo in "${COPR_REPOS[@]}"; do
    dnf5 -y copr enable "$repo"
done

log "Install layered applications"

# Layered Applications
LAYERED_PACKAGES=(
    cifs_utils
    kcalc
    konsole
    kate
    #kvantum
    syncthing
    filezilla
    firefox
    firefox-langpacks
    lact

)
dnf5 install --setopt=install_weak_deps=False -y "${LAYERED_PACKAGES[@]}"

log "Disable Copr repos as we do not need it anymore"

for repo in "${COPR_REPOS[@]}"; do
    dnf5 -y copr disable "$repo"
done
