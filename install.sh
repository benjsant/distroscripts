#!/bin/bash

set -e

# Vérifier que le script n'est pas lancé en root
if [ "$EUID" -eq 0 ]; then
  echo "❌ Ce script ne doit pas être lancé en root."
  exit 1
fi

# Vérifier la présence de distrobox
if ! command -v distrobox >/dev/null 2>&1; then
  echo "❌ Distrobox n'est pas installé."
  echo "💡 Installe-le avec :"
  echo "    sudo dnf install distrobox"
  exit 1
fi

# Créer dossier ~/distrobox si absent
if [ ! -d "$HOME/distrobox" ]; then
  echo "📁 Création du dossier $HOME/distrobox"
  mkdir -p "$HOME/distrobox"
fi

echo "✅ Prérequis OK"

# Appel du script gaming/install.sh avec option --home $HOME/distrobox/nom_box
echo "🚀 Lancement de l'installation de l'environnement gaming..."
./gaming/install.sh --home "$HOME/distrobox/fedora_gaming_final"

# Ici tu peux ajouter d'autres appels à d'autres scripts d'installation si besoin
# Ex :
# echo "🚀 Lancement de l'installation de l'environnement dev..."
# ./dev/install.sh --home "$HOME/distrobox/dev_box"

echo ""
echo "🎉 Installation générale terminée !"
