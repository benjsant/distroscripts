#!/bin/bash

set -e

BOX_NAME="fedora_gaming"

echo "🟣 Configuration GPU AMD dans la Distrobox '$BOX_NAME'..."

distrobox enter "$BOX_NAME" -- bash -c "

  echo '🔄 Mise à jour du système...'
  sudo dnf update -y

  echo '🎮 Installation des bibliothèques et outils pour GPU AMD...'
  sudo dnf install -y \\
    mesa-vulkan-drivers \\
    mesa-va-drivers \\
    mesa-vdpau-drivers \\
    libva libva-utils \\
    vdpauinfo libdrm \\
    vulkan-loader vulkan-tools \\
    glx-utils

  echo ''
  echo '✅ Configuration AMD terminée avec succès.'
  echo '💡 Tu peux tester avec : vulkaninfo, glxinfo, vkcube...'
"
