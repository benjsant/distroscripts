#!/bin/bash

set -e

BOX_NAME="fedora_gaming"
PACKAGE_FILE="packages.txt"

if [ ! -f "$PACKAGE_FILE" ]; then
  echo "❌ Fichier packages.txt introuvable."
  exit 1
fi

echo "📦 Installation des paquets listés dans packages.txt..."

distrobox enter "$BOX_NAME" -- bash -c "
  echo '📜 Lecture du fichier packages.txt...'
  xargs -a $PACKAGE_FILE sudo dnf install -y
  echo ''
  echo '✅ Tous les paquets ont été installés.'
"
