#!/bin/bash

set -e

### ❌ Vérification root
if [ "$EUID" -eq 0 ]; then
  echo "❌ Ce script ne doit pas être lancé en tant que root."
  exit 1
fi

### 🔎 Vérification des prérequis
if ! command -v distrobox >/dev/null 2>&1; then
  echo "❌ Distrobox est introuvable."
  exit 1
fi

if ! command -v podman >/dev/null 2>&1 && ! command -v docker >/dev/null 2>&1; then
  echo "❌ Aucun moteur de conteneur compatible (podman ou docker) détecté."
  exit 1
fi

### 📁 Vérification dossier base
if [ ! -d "$HOME/distrobox" ]; then
  echo "📁 Création du dossier $HOME/distrobox"
  mkdir -p "$HOME/distrobox"
fi

echo ""
echo "✅ Prérequis OK"
echo ""

### 📜 Menu interactif
echo "📦 Quelle Distrobox souhaitez-vous installer ?"
echo "1) Fedora Gaming"
echo "2) Ubuntu Dev Hugo"
echo "3) Ubuntu Dev Python"
echo "4) Ubuntu Dev IA"
echo "q) Quitter"
read -rp "👉 Votre choix : " choix

case "$choix" in
  1)
    echo "🚀 Installation de Fedora Gaming..."
    ./fedora_gaming/install.sh --home "$HOME/distrobox/fedora_gaming"
    ;;
  2)
    echo "🚀 Installation de Ubuntu Dev Hugo..."
    ./ubuntu_dev_hugo/install.sh --home "$HOME/distrobox/ubuntu_dev_hugo"
    ;;
  3)
    echo "🚀 Installation de Ubuntu Dev Python..."
    ./ubuntu_dev_python/install.sh --home "$HOME/distrobox/ubuntu_dev_python"
    ;;
  4)
    echo "🚀 Installation de Ubuntu Dev IA..."
    ./ubuntu_dev_ia/install.sh --home "$HOME/distrobox/ubuntu_dev_ia"
    ;;
  q|Q)
    echo "👋 Sortie du script."
    exit 0
    ;;
  *)
    echo "❌ Choix invalide."
    exit 1
    ;;
esac

echo ""
echo "🎉 Installation terminée ! Utilisez 'distrobox enter <nom>' pour y accéder."
