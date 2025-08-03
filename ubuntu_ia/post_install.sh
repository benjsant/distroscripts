#!/bin/bash
set -e

MODE="${1:-cpu}"  # gpu mode: cpu, cuda, rocm

echo "🔧 Mise à jour..."
sudo apt update && sudo apt upgrade -y

echo "📦 Paquets de base + Python..."
sudo apt install -y curl git wget build-essential python3 python3-pip ca-certificates gnupg lsb-release

echo "🧠 Installation d'Ollama..."
curl -fsSL https://ollama.com/install.sh | bash

### 🎮 Configuration GPU
case "$MODE" in
  rocm)
    echo "➡️ ROCm : configuration..."
    if [ -d /opt/rocm ]; then
      echo "✅ ROCm trouvé."
      export PATH="/opt/rocm/bin:$PATH"
      export LD_LIBRARY_PATH="/opt/rocm/lib:$LD_LIBRARY_PATH"
    else
      echo "⚠️ ROCm introuvable dans la Distrobox."
    fi
    ;;
  cuda)
    echo "➡️ CUDA : vérification..."
    if command -v nvidia-smi &>/dev/null; then
      echo "✅ NVIDIA GPU OK."
    else
      echo "⚠️ nvidia-smi non disponible."
    fi
    ;;
  cpu)
    echo "➡️ Mode CPU : aucun GPU activé."
    ;;
  *)
    echo "⚠️ Mode inconnu : $MODE"
    ;;
esac

echo "🖥️ Installation de Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code

echo "📂 Configuration du pack de langue français (facultatif)..."
code --install-extension MS-CEINTL.vscode-language-pack-fr
mkdir -p "$HOME/.config/Code/User"
echo '{ "locale": "fr" }' > "$HOME/.config/Code/User/locale.json"

echo ""
echo "📦 Les extensions VS Code peuvent être installées avec :"
echo "    xargs -n 1 code --install-extension < vscode-extensions.txt"
echo "📄 Assure-toi que le fichier 'vscode-extensions.txt' est présent dans ce répertoire."

echo "🐍 Installation de pyenv..."
if [ ! -d "$HOME/.pyenv" ]; then
  curl https://pyenv.run | bash
else
  echo "🔁 pyenv déjà installé, mise à jour..."
  cd "$HOME/.pyenv" && git pull
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

echo "📦 Installation de la dernière version stable de Python..."
LATEST_PYTHON=$(pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
pyenv install -s "$LATEST_PYTHON"
pyenv global "$LATEST_PYTHON"

echo ""
echo "✅ Environnement IA prêt avec Ollama, VS Code, Python ($LATEST_PYTHON) [mode: $MODE]"
