#!/bin/bash
set -e

### 📌 Configuration
BOX_NAME="fedora_gaming"
FEDORA_IMAGE="quay.io/fedora/fedora-toolbox:41"
HOST_UID=$(id -u)
XDG_RUNTIME_DIR="/run/user/${HOST_UID}"
DBUS_SOCKET="${XDG_RUNTIME_DIR}/bus"
HOME_DIR="$HOME/distrobox/$BOX_NAME"
SCRIPT_DIR="$(pwd)/$BOX_NAME"

### ❌ Refuser root
if [ "$EUID" -eq 0 ]; then
  echo "❌ Ce script ne doit pas être exécuté en tant que root."
  exit 1
fi

### ✅ Vérifier D-Bus
if [ ! -S "$DBUS_SOCKET" ]; then
  echo "❌ DBus non détecté à $DBUS_SOCKET"
  echo "💡 Lance une session graphique ou exporte DBus avec : export \$(dbus-launch)"
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

### 📄 Copier les scripts nécessaires dans le home
cp "$SCRIPT_DIR/setup_repos.sh" "$HOME_DIR/"
cp "$SCRIPT_DIR/config_amd.sh" "$HOME_DIR/"
cp "$SCRIPT_DIR/install_packages.sh" "$HOME_DIR/"
cp "$SCRIPT_DIR/packages.txt" "$HOME_DIR/"

### 🚧 Création de la Distrobox
echo "🎮 Création de la Distrobox Fedora pour le gaming..."

distrobox-create \
  --name "$BOX_NAME" \
  --image "$FEDORA_IMAGE" \
  --init \
  --home "$HOME_DIR" \
  --additional-flags "\
    --device /dev/dri \
    --device /dev/snd \
    --device /dev/input \
    --cap-add SYS_PTRACE \
    --security-opt seccomp=unconfined \
    --volume=${XDG_RUNTIME_DIR}:${XDG_RUNTIME_DIR} \
    --volume=/run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
    --env=DBUS_SESSION_BUS_ADDRESS=unix:path=${DBUS_SOCKET}"

### 🚀 Lancer les scripts post-install à l’intérieur de la Distrobox
echo "⚙️ Lancement des scripts post-install dans la Distrobox..."

distrobox enter "$BOX_NAME" -- bash -c "bash ~/setup_repos.sh && bash ~/config_amd.sh && bash ~/install_packages.sh"

echo ""
echo "✅ Distrobox '$BOX_NAME' prête à l'emploi !"
echo "👉 Entre dans l’environnement avec : distrobox enter $BOX_NAME"
