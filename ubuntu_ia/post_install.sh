#!/bin/bash
set -e

echo "🔧 Mise à jour..."
sudo apt update && sudo apt upgrade -y

echo "📦 Paquets de base + Python..."
sudo apt install -y curl git wget build-essential python3 python3-pip ca-certificates gnupg lsb-release

echo "🧠 Installation d'Ollama (compatible Ubuntu 22.04)..."
curl -fsSL https://ollama.com/install.sh | bash

echo "🖥️ Installation de Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code

echo "🐍 Installation de pyenv..."
curl https://pyenv.run | bash

# Init pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

echo "📦 Installation dernière version stable de Python..."
LATEST_PYTHON=$(pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
pyenv install "$LATEST_PYTHON"
pyenv global "$LATEST_PYTHON"

echo ""
echo "✅ Environnement IA prêt avec Ollama, Python et VS Code."
