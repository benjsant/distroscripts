#!/bin/bash
set -e

### 📌 Configuration
BOX_NAME="ubuntu_dev_python"
UBUNTU_IMAGE="quay.io/toolbx/ubuntu-toolbox:24.04"
HOME_DIR="$HOME/distrobox/$BOX_NAME"

SCRIPT_DIR="$(pwd)/$BOX_NAME"

### ❌ Interdiction root
if [ "$EUID" -eq 0 ]; then
  echo "❌ Ne pas exécuter ce script en tant que root."
  exit 1
fi

### 🔁 Vérifier si la Distrobox existe déjà
if distrobox list | grep -q "$BOX_NAME"; then
  echo "⚠️ Une Distrobox nommée '$BOX_NAME' existe déjà."
  read -rp "🔁 Voulez-vous la supprimer et la recréer ? (o/N) " confirm
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

### 🧱 Création de la Distrobox
echo "📦 Création de la Distrobox Ubuntu pour le dev Python..."

distrobox-create \
  --name "$BOX_NAME" \
  --image "$UBUNTU_IMAGE" \
  --home "$HOME_DIR"

### 🚀 Exécuter le post-install
echo "⚙️ Lancement du post-install dans la Distrobox..."

distrobox enter "$BOX_NAME" -- bash $SCRIPT_DIR/post_install.sh

echo ""
echo "✅ Distrobox '$BOX_NAME' prête à l'emploi !"
echo "👉 Entre dans l’environnement avec : distrobox enter $BOX_NAME"
