#!/bin/bash
set -e

BOX_NAME="ubuntu_dev_ia"
UBUNTU_IMAGE="quay.io/toolbx/ubuntu-toolbox:22.04"
HOME_DIR="$HOME/distrobox/$BOX_NAME"
SCRIPT_DIR="$(pwd)/$BOX_NAME"
GPU_MODE="cpu"
EXTRA_FLAGS=""

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

### 🔍 Détection du support GPU
if [ -d /opt/rocm ]; then
  echo "✅ ROCm détecté sur l’hôte."
  GPU_MODE="rocm"
  EXTRA_FLAGS="--volume=/opt/rocm:/opt/rocm"
elif command -v nvidia-smi &>/dev/null; then
  echo "✅ NVIDIA GPU détecté (CUDA)."
  GPU_MODE="cuda"
else
  echo "⚠️ Aucun support GPU détecté."
  read -rp "🔧 Continuer en mode CPU ? (o/N) " confirm_cpu
  if [[ ! "$confirm_cpu" =~ ^[oO]$ ]]; then
    echo "❌ Installation annulée."
    exit 1
  fi
fi

### 🧱 Création de la Distrobox avec les bons paramètres
distrobox-create \
  --name "$BOX_NAME" \
  --image "$UBUNTU_IMAGE" \
  --init \
  --home "$HOME_DIR" \
  --additional-packages "systemd" \
  --additional-flags "--device=/dev/dri $EXTRA_FLAGS"

### 🚀 Post-installation
echo "⚙️ Post-installation dans la Distrobox..."
distrobox enter "$BOX_NAME" -- bash "$SCRIPT_DIR/post_install.sh" "$GPU_MODE"

echo ""
echo "✅ Distrobox '$BOX_NAME' prête à l'emploi !"
echo "👉 Entre avec : distrobox enter $BOX_NAME"
