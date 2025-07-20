#!/bin/bash

set -e

BOX_NAME="fedora_gaming_final"

echo "📦 Activation de RPM Fusion et des dépôts COPR dans '$BOX_NAME'..."

distrobox enter "$BOX_NAME" -- bash -c "

  # RPM Fusion
  sudo dnf install -y \\
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-\$(rpm -E %fedora).noarch.rpm \\
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-\$(rpm -E %fedora).noarch.rpm

  # COPR Heroic
  sudo dnf -y copr enable atim/heroic-games-launcher

  # COPR ProtonPlus
  sudo dnf -y copr enable wehagy/protonplus

  echo ''
  echo '✅ Dépôts activés.'
"
