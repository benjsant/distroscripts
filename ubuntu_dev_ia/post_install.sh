#!/bin/bash
set -e

MODE="${1:-cpu}"

echo "🔧 Mise à jour du système et installation des paquets de base..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installation des dépendances nécessaires (pyenv, build tools)..."
xargs sudo apt install -y < ~/packages.txt

echo "🧠 Installation d'Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

echo "🐍 Installation / mise à jour de pyenv..."
if [ ! -d "$HOME/.pyenv" ]; then
  curl https://pyenv.run | bash
else
  echo "🔁 pyenv déjà installé, mise à jour..."
  cd "$HOME/.pyenv" && git pull
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

echo "📦 Installation de la dernière version stable de Python..."
LATEST_PYTHON=$(pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
pyenv install -s "$LATEST_PYTHON"
pyenv global "$LATEST_PYTHON"

echo "🖥️ Installation de Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
rm microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code

mkdir -p "$HOME/.config/Code/User"
echo '{ "locale": "fr" }' > "$HOME/.config/Code/User/locale.json"

echo "🎮 Configuration GPU : $MODE"
case "$MODE" in
  rocm)
    echo "➡️ ROCm détecté, assure-toi que les drivers ROCm sont bien installés sur l’hôte."
    ;;
  nvidia)
    echo "➡️ GPU NVIDIA détecté, assure-toi que les drivers NVIDIA sont bien installés sur l’hôte."
    ;;
  cpu)
    echo "➡️ Aucun GPU compatible détecté, utilisation CPU uniquement."
    ;;
  *)
    echo "⚠️ Mode GPU inconnu : $MODE"
    ;;
esac

echo ""
echo "✅ Installation terminée. Ollama, pyenv, VS Code et Python $LATEST_PYTHON sont prêts."
echo "ℹ️ Pour Ollama, n’oublie pas d’installer tes modèles dans la Distrobox."
