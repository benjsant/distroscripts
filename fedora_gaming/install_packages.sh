#!/bin/bash
set -e

PACKAGE_FILE="$HOME/packages.txt"

echo "📂 Chemin du fichier : $PACKAGE_FILE"

if [ ! -f "$PACKAGE_FILE" ]; then
  echo "❌ Fichier packages.txt introuvable."
  exit 1
fi

echo "📦 Installation des paquets listés dans packages.txt..."

echo "📜 Lecture du fichier packages.txt..."
xargs -a "$PACKAGE_FILE" sudo dnf install -y

echo ""
echo "✅ Tous les paquets ont été installés."

