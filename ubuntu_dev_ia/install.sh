#!/bin/bash
set -e

### 📌 Configuration
BOX_NAME="ubuntu_dev_ia"
UBUNTU_IMAGE="quay.io/toolbx/ubuntu-toolbox:24.04"
HOME_DIR="$HOME/distrobox/$BOX_NAME"
SCRIPT_DIR="$(pwd)/$BOX_NAME"

### ❌ Ne pas lancer en root
if [ "$EUID" -eq 0 ]; then
  echo "❌ Ce script ne doit pas être exécuté en tant que root."
  exit 1
fi

### 🔍 Détection GPU (NVIDIA ou ROCm)
MODE="cpu"  # défaut

if command -v lspci &>/dev/null; then
  if lspci | grep -i 'NVIDIA' >/dev/null 2>&1; then
    MODE="nvidia"
  elif lspci | grep -i 'AMD/ATI' >/dev/null 2>&1 && ls /opt/rocm* &>/dev/null; then
    MODE="rocm"
  fi
fi

if [ "$MODE" = "cpu" ]; then
  echo "⚠️ Aucun GPU NVIDIA ou ROCm détecté."
  read -rp "Voulez-vous continuer en mode CPU ? (o/N) " answer
  if [[ ! "$answer" =~ ^[oO]$ ]]; then
    echo "❌ Installation annulée."
    exit 1
  fi
fi

echo "ℹ️ Mode GPU sélectionné : $MODE"

### 🔁 Vérifier si la Distrobox existe déjà
if distrobox list | grep -q "$BOX_NAME"; then
  echo "⚠️ Une Distrobox nommée '$BOX_NAME' existe déjà."
  read -rp "Voulez-vous la supprimer et la recréer ? (o/N) " confirm
  if [[ "$confirm" =~ ^[oO]$ ]]; then
    echo "🗑️ Suppression de l'ancienne Distrobox..."
    distrobox rm "$BOX_NAME" --force
    rm -rf "$HOME_DIR"
  else
    echo "❌ Annulation."
    exit 1
  fi
fi

### 📁 Créer le dossier home
mkdir -p "$HOME_DIR"

### 📄 Copier les scripts nécessaires dans le home
cp "$SCRIPT_DIR/post_install.sh" "$HOME_DIR/"
cp "$SCRIPT_DIR/packages.txt" "$HOME_DIR/"

### 🧱 Construction des flags selon GPU
EXTRA_FLAGS="--device=/dev/dri"
if [ "$MODE" = "rocm" ]; then
  ROCM_PATH=$(find /opt -maxdepth 1 -type d -name "rocm*" | sort | tail -1)
  if [ -n "$ROCM_PATH" ]; then
    EXTRA_FLAGS="$EXTRA_FLAGS --volume=$ROCM_PATH:$ROCM_PATH"
  else
    echo "⚠️ Mode rocm choisi mais dossier ROCm non trouvé dans /opt"
  fi
elif [ "$MODE" = "nvidia" ]; then
  EXTRA_FLAGS="$EXTRA_FLAGS --nvidia"
fi

### 🚧 Création de la Distrobox
echo "🚀 Création de la Distrobox '$BOX_NAME' avec mode GPU : $MODE"

distrobox-create \
  --name "$BOX_NAME" \
  --image "$UBUNTU_IMAGE" \
  --init \
  --home "$HOME_DIR" \
  --additional-packages "systemd" \
  --additional-flags "$EXTRA_FLAGS"

### 🚀 Lancement du post-install dans la Distrobox avec passage du mode GPU
echo "⚙️ Lancement du post-install dans la Distrobox avec mode GPU : $MODE..."

distrobox enter "$BOX_NAME" -- bash -c "~/post_install.sh $MODE"

echo ""
echo "✅ Distrobox '$BOX_NAME' prête à l'emploi !"
echo "👉 Lance l’environnement avec : distrobox enter $BOX_NAME"
