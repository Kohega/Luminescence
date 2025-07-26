#!/usr/bin/env bash
  set -euo pipefail

  echo "Enabling Virtual Dummy Display"

  if ! rpm-ostree kargs | grep -q "drm.edid_firmware="; then
    echo "Updating rpm-ostree kernel arguments"
    sudo rpm-ostree kargs --append "drm.edid_firmware=HDMI-A-1:edid/dummy-full.bin video=HDMI-A-1:e"
  else
    echo "Already enabled"
  fi
