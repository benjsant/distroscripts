#!/bin/bash
set -e

echo "🔧 Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installation des paquets de base..."
if [ -f ~/packages.txt ]; then
    xargs -a ~/packages.txt sudo apt install -y
else
    echo "❌ Fichier ~/packages.txt introuvable."
    exit 1
fi

### 🍺 Homebrew
if ! command -v brew &>/dev/null; then
    echo "🍺 Installation de Homebrew..."
    NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew déjà installé."
fi

echo "🔄 Ajout de Homebrew au PATH dans ~/.bashrc..."
BREW_LINE='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
if ! grep -Fxq "$BREW_LINE" ~/.bashrc; then
    echo "$BREW_LINE" >> ~/.bashrc
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

### 🚀 Hugo
if ! command -v hugo &>/dev/null; then
    echo "📦 Installation de Hugo..."
    brew install hugo
else
    echo "✅ Hugo déjà installé."
fi

### 🖥️ Visual Studio Code
if ! command -v code &>/dev/null; then
    echo "🖥️ Installation de Visual Studio Code..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
    rm -f microsoft.gpg
else
    echo "✅ Visual Studio Code déjà installé."
fi

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

echo ""
echo "✅ Installation complète ! Tu peux maintenant utiliser Hugo, Node, VS Code, etc."
