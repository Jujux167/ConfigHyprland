# 📋 Prérequis pour l'installation

## Paquets de base nécessaires sur Arch Linux

Avant de lancer le script `fullsetup.sh`, assure-toi d'avoir ces paquets installés sur ton Arch Linux frais :

### Installation manuelle des prérequis :

```bash
# Mise à jour du système
pacman -Syu

# Installation des paquets essentiels
pacman -S base-devel git sudo curl wget
```

### Détail des paquets requis :

- **`base-devel`** : Groupe de paquets pour compiler (gcc, make, etc.) - nécessaire pour AUR
- **`git`** : Pour cloner ce repository et installer yay
- **`sudo`** : Pour les droits administrateur (le script doit être lancé avec sudo)
- **`curl`** : Pour télécharger des ressources en ligne
- **`wget`** : Alternative à curl pour certains téléchargements

### Configuration utilisateur :

Si ce n'est pas déjà fait, ajoute ton utilisateur au groupe `wheel` pour sudo :

```bash
# En tant que root
usermod -aG wheel ton_nom_utilisateur

# Décommente la ligne %wheel dans sudoers
visudo
# Décommente : %wheel ALL=(ALL:ALL) ALL
```

## 🚀 Installation

Une fois les prérequis installés :

```bash
# Clone le repository
git clone https://github.com/Jujux167/ConfigHyprland.git
cd ConfigHyprland

# Lance l'installation
sudo ./fullsetup.sh
```

## 📦 Ce que le script installera automatiquement :

- Hyprland + tous ses modules (hyprpaper, hyprlock, etc.)
- Waybar avec monitoring GPU/CPU
- Rofi avec thème Catppuccin
- Kitty terminal configuré
- Pilotes NVIDIA (si détecté)
- PipeWire pour l'audio
- NetworkManager + Bluetooth
- Thèmes GTK et icônes
- Applications essentielles (Firefox, VS Code, etc.)
- Police FiraCode Nerd Font
- Configuration clavier français (AZERTY)

Le script gère tout automatiquement après l'installation des prérequis ! ✨
