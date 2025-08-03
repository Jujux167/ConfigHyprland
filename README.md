# 🚀 HyDE-like Setup for Hyprland

Un script d'installation automatique pour créer un environnement Hyprland moderne et stylé, inspiré de HyDE.

## ✨ Fonctionnalités

- **Hyprland** avec configuration française complète
- **Waybar** stylée avec monitoring système
- **Rofi** avec thème moderne
- **Kitty** terminal avec thème Catppuccin
- **Thèmes** cohérents (WhiteSur, Tela icons, Bibata cursors)
- **Animations** fluides et modernes
- **Monitoring GPU** NVIDIA intégré
- **Fond d'écran** automatique

## 🎯 Optimisé pour

- RTX 4050 / NVIDIA
- i7 / CPU performants
- Clavier français (AZERTY)
- Arch Linux

## 🚀 Installation

### Méthode rapide (one-liner)
```bash
curl -L https://raw.githubusercontent.com/Jujux167/ConfigHyprland/main/fullsetup.sh | sudo bash
```

### Méthode manuelle
```bash
git clone https://github.com/Jujux167/ConfigHyprland.git
cd ConfigHyprland
chmod +x fullsetup.sh
sudo ./fullsetup.sh
```

## 📋 Prérequis

- Arch Linux fraîchement installé
- Utilisateur non-root créé avec sudo
- Connexion internet active

## ⌨️ Raccourcis principaux

| Raccourci | Action |
|-----------|---------|
| `SUPER + &,é,",',(,-,è,_,ç,à` | Workspaces 1-10 |
| `SUPER + A` | Terminal |
| `SUPER + R` | Menu applications |
| `SUPER + E` | Explorateur |
| `SUPER + B` | Firefox |
| `SUPER + C` | Fermer fenêtre |
| `SUPER + V` | Mode flottant |
| `SUPER + F` | Plein écran |
| `SUPER + L` | Verrouiller |
| `Print` | Capture écran |

## 🎨 Thème

- **Couleurs** : Catppuccin Mocha
- **Police** : FiraCode Nerd Font
- **Icônes** : Tela (moderne et coloré)
- **Curseur** : Bibata (élégant)
- **GTK** : WhiteSur (style macOS)

## 📦 Applications incluses

### Essentielles
- Firefox, VLC, VS Code
- Pavucontrol, File-roller
- Neofetch, Btop

### AUR
- Google Chrome, Spotify
- VS Code officiel
- Thèmes premium

## 🔧 Post-installation

Après installation :
1. Redémarrer le système
2. Se connecter via Ly
3. Profiter de l'expérience HyDE-like !

## 💡 Personnalisation

Les fichiers de config sont dans :
- `~/.config/hypr/hyprland.conf` - Configuration Hyprland
- `~/.config/waybar/` - Barre des tâches
- `~/.config/kitty/` - Terminal
- `~/.config/rofi/` - Lanceur d'applications

---
*Inspiré par HyDE - Hyprland Desktop Environment*