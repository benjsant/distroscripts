#!/bin/bash

set -e

### 📌 Configuration de base
BOX_NAME="fedora_gaming"
FEDORA_IMAGE="quay.io/fedora/fedora-toolbox:41"
HOST_UID=$(id -u)
XDG_RUNTIME_DIR="/run/user/${HOST_UID}"
DBUS_SOCKET="${XDG_RUNTIME_DIR}/bus"
HOME_OPTION="$1"  # Ex: --home /chemin/vers/home perso ou vide

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

### 🚧 Création de la Distrobox
echo "🎮 Création de la Distrobox Fedora pour le gaming..."

distrobox-create \
  --name "$BOX_NAME" \
  --image "$FEDORA_IMAGE" \
  --init \
  $HOME_OPTION \
  --additional-flags "\
    --device /dev/dri \
    --device /dev/snd \
    --device /dev/input \
    --cap-add SYS_PTRACE \
    --security-opt seccomp=unconfined \
    --volume=${XDG_RUNTIME_DIR}:${XDG_RUNTIME_DIR} \
    --volume=/run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
    --env=DBUS_SESSION_BUS_ADDRESS=unix:path=${DBUS_SOCKET}"

echo ""
echo "✅ Distrobox '$BOX_NAME' créée avec succès."

### 🚀 Lancement automatique des scripts post-install

echo "📦 Activation des dépôts RPM Fusion et COPR..."
./setup_repos.sh

echo "🟣 Configuration du support GPU AMD..."
./config_amd.sh

echo "🧰 Installation des paquets depuis la liste packages.txt..."
./install_packages.sh

echo ""
echo "🎉 Installation terminée ! Tu peux maintenant entrer dans ta Distrobox avec :"
echo "   distrobox enter $BOX_NAME"
