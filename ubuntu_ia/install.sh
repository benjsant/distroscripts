#!/bin/bash
set -e

BOX_NAME="ubuntu_dev_ia"
UBUNTU_IMAGE="quay.io/toolbx/ubuntu-toolbox:22.04"
HOME_DIR="$HOME/distrobox/$BOX_NAME"
SCRIPT_DIR="$(pwd)/$BOX_NAME"

if [ "$EUID" -eq 0 ]; then
  echo "❌ Ne pas exécuter ce script en tant que root."
  exit 1
fi

### 🔁 Vérification de la Distrobox existante
if distrobox list | grep -q "$BOX_NAME"; then
  echo "⚠️ La Distrobox '$BOX_NAME' existe déjà."
  read -rp "🔁 Supprimer et recréer ? (o/N) " confirm
  if [[ "$confirm" =~ ^[oO]$ ]]; then
    echo "🗑️ Suppression..."
    distrobox rm "$BOX_NAME" --force
    rm -rf "$HOME_DIR"
  else
    echo "❌ Annulation."
    exit 1
  fi
fi

mkdir -p "$HOME_DIR"

### 🧱 Création de la Distrobox avec support GPU
distrobox-create \
  --name "$BOX_NAME" \
  --image "$UBUNTU_IMAGE" \
  --init \
  --home "$HOME_DIR" \
  --additional-packages "systemd" \
  --additional-flags "--device=/dev/dri --volume=/opt/rocm-6.4.0:/opt/rocm-6.4.0"

### 🚀 Post-installation
echo "⚙️ Post-installation dans la Distrobox..."
distrobox enter "$BOX_NAME" -- bash "$SCRIPT_DIR/post_install.sh"

echo ""
echo "✅ Distrobox '$BOX_NAME' prête à l'emploi !"
echo "👉 Entre avec : distrobox enter $BOX_NAME"
