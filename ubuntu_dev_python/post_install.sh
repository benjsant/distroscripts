#!/bin/bash
set -e

BOX_NAME="ubuntu_dev_python"
SCRIPT_DIR="$(pwd)/$BOX_NAME"
PACKAGE_FILE="$SCRIPT_DIR/packages.txt"

echo "📂 Chemin du fichier : $PACKAGE_FILE"

if [ ! -f "$PACKAGE_FILE" ]; then
  echo "❌ Fichier packages.txt introuvable."
  exit 1
fi

echo "🔧 Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installation des paquets de base..."
echo "📜 Lecture du fichier packages.txt..."
xargs -a "$PACKAGE_FILE" sudo apt install -y

echo "🐍 Installation de pyenv..."
curl https://pyenv.run | bash

echo "🔄 Configuration de l’environnement pour pyenv..."
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc

### 🔧 NVM + Node.js LTS
if [ ! -d "$HOME/.nvm" ]; then
    echo "🌐 Installation de NVM et Node.js LTS..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
else
    echo "✅ NVM déjà installé."
fi

# Charger NVM
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Installer Node LTS si pas déjà installé
if ! command -v node &>/dev/null; then
    nvm install --lts
fi

### 🎨 Prompt personnalisé (optionnel)
if ! grep -q '📦[\u@\h \W]\\$' ~/.bashrc; then
    echo 'export PS1="📦[\u@\h \W]\\$ "' >> ~/.bashrc
fi

# 🐍 Initialisation de pyenv dans le shell
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

echo "🐍 Installation de Python 3.12.3 (exemple)..."
pyenv install 3.13.3
pyenv global 3.13.3

echo "✅ Python configuré avec pyenv"