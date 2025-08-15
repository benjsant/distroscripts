# 📦 DistroScript

![image](featured_image.png)

**DistroScript** est un ensemble de scripts Bash permettant de créer et configurer automatiquement des environnements de développement ou gaming isolés grâce à **Distrobox**.  
Chaque environnement est basé sur une image Linux spécifique et préinstallé avec les outils nécessaires à un usage ciblé.

* * *

## 🚀 Fonctionnalités

- Création automatisée de **Distrobox** dédiées selon le besoin.
- Scripts de **post-installation** pour configurer chaque environnement.
- Installation des dépendances et outils spécifiques.
- **Isolation** tout en gardant l’accès aux fichiers et périphériques de l’hôte.
- Choix interactif de l’environnement à installer.

* * *

## 📋 Environnements disponibles

| Nom | Base | Usage principal |
| --- | --- | --- |
| `fedora_gaming` | Fedora Toolbox | Gaming Linux avec ProtonUp-Qt, Heroic, émulateurs |
| `ubuntu_dev_ia` | Ubuntu 24.04 | IA & Machine Learning avec accélération GPU si dispo |
| `ubuntu_dev_hugo` | Ubuntu 24.04 | Développement de sites statiques avec Hugo |
| `ubuntu_dev_python` | Ubuntu 24.04 | Dev Python avec Pyenv pour versions multiples |

* * *

## 📦 Pré-requis

- Un système **Linux** (Distrobox n’est pas compatible Windows/macOS nativement)
- **Podman** ou **Docker** installé et configuré
- **Distrobox** installé 
- Connexion Internet
- Espace disque suffisant (certains environnements sont lourds)
- Droits sudo pour installer certains paquets

* * *

## ⚙️ Installation

1.  **Cloner le dépôt**

```bash
git clone https://github.com/benjsant/distroscripts.git
cd distroscripts
```

2.  \*\*Lancer le script de création  
    \*\*
    
    ```bash
    ./install.sh
    ```
    

* * *

## 📂 Structure du projet

```bash
.
├── fedora_gaming
│   ├── config_amd.sh
│   ├── install_packages.sh
│   ├── install.sh
│   ├── packages.txt
│   └── setup_repos.sh
├── install.sh
├── LICENSE
├── README.md
├── ubuntu_dev_hugo
│   ├── install.sh
│   ├── packages.txt
│   └── post_install.sh
├── ubuntu_dev_ia
│   ├── install.sh
│   ├── packages.txt
│   └── post_install.sh
└── ubuntu_dev_python
    ├── install.sh
    ├── packages.txt
    └── post_install.sh
```

* * *

## ⚠️ Limitations et contraintes par environnement

### **Générales**

- **Linux uniquement** : Distrobox ne fonctionne pas nativement sur Windows/macOS.
    
- **Performances** : Dépendent du matériel de l’hôte (CPU, RAM, GPU).
    
- **Accès périphériques** : Certaines applications nécessitent des permissions supplémentaires (USB, GPU).
    
- **Ressources** : Certaines Distrobox peuvent être lourdes et nécessiter plusieurs Go d’espace disque.
    

* * *

### **fedora_gaming**

- **GPU AMD recommandé** : Pour exploiter pleinement Mesa et Proton.
    
- **Stockage** : Les jeux peuvent occuper plusieurs dizaines de Go.
    
- **Compatibilité périphériques** : Certains outils (ex. Sunshine) peuvent demander des accès matériels spécifiques.
    
- **CPU** : Les performances des jeux peuvent être limitées sur des CPU anciens ou à faible nombre de cœurs.
    

* * *

### **ubuntu_dev_ia**

- **Accélération GPU** : CUDA (NVIDIA) ou ROCm (AMD) utilisables uniquement si le matériel et les pilotes sont déjà installés sur l’hôte.
    
- **Mode CPU** : En absence de GPU compatible, les traitements IA seront beaucoup plus lents.
    
- **Poids** : Les frameworks IA peuvent prendre plusieurs Go.
    
- **Dépendances** : Certaines librairies IA peuvent nécessiter des versions spécifiques de Python ou GCC.
    
- **Mémoire** : Les modèles IA peuvent consommer plusieurs dizaines de Go de RAM si exécutés entièrement.
    

* * *

### **ubuntu_dev_hugo**

- **Accès réseau** : Le serveur local de Hugo peut être inaccessible si certains ports sont bloqués.
    
- **VPN** : Peut interférer avec le hot reload.
    
- **Performances** : Dépend du CPU pour le build rapide de gros sites.
    

* * *

### **ubuntu_dev_python**

- **Temps d’installation** : Pyenv compile Python depuis les sources → long sur machines modestes.
    
- **Dépendances** : La liste `packages.txt` est spécifique à Ubuntu, à adapter si image modifiée.
    
- **Versions multiples** : La gestion de plusieurs versions Python peut complexifier l’environnement si mal configurée.
    

* * *

## 💡 Conseils d’utilisation

- Sauvegardez vos données importantes **hors** de la Distrobox.
    
- Utilisez `distrobox enter <nom>` pour accéder rapidement à l’environnement.
    
- Nettoyez régulièrement les images inutilisées avec `podman image prune` ou `docker image prune`.
    
- Vérifiez que vos périphériques (GPU, USB, HDMI) sont accessibles depuis l’hôte si vous prévoyez un usage intensif.
    
- Pour les environnements IA, privilégiez un GPU dédié si possible pour des performances optimales.
    

* * *