# 🚀 Installation sur nouvelle machine Arch Linux

## Méthode simple (repo public) :

```bash
# 1. Installe les prérequis minimum
sudo pacman -S base-devel git sudo

# 2. Clone le repo (pas besoin de connexion Git pour un repo public)
git clone https://github.com/Jujux167/ConfigHyprland.git
cd ConfigHyprland

# 3. Lance l'installation
sudo ./fullsetup-new.sh
```

## Alternative avec curl (si Git pose problème) :

```bash
# Télécharge et décompresse
curl -L https://github.com/Jujux167/ConfigHyprland/archive/main.zip -o hyprland.zip
unzip hyprland.zip
cd ConfigHyprland-main

# Lance le script
sudo ./fullsetup-new.sh
```

## One-liner complet :

```bash
sudo pacman -S base-devel git sudo && git clone https://github.com/Jujux167/ConfigHyprland.git && cd ConfigHyprland && sudo ./fullsetup-new.sh
```

## Troubleshooting Git :

Si tu as des erreurs Git, essaie :

```bash
# Réinitialise la config Git
git config --global --unset-all user.name
git config --global --unset-all user.email

# Ou configure juste pour ce clone
git config user.name "TonNom"
git config user.email "ton@email.com"
```

**Note** : Pour un repo **public**, tu n'as besoin d'aucune authentification ! 🎯

## 🔧 Après installation - Si Ly ne se lance pas :

```bash
# Vérifie le statut de Ly
sudo systemctl status ly

# Si inactif, active-le manuellement
sudo systemctl enable ly
sudo systemctl start ly

# Désactive les autres display managers s'ils existent
sudo systemctl disable gdm sddm lightdm 2>/dev/null

# Redémarre pour tester
sudo reboot
```

## 🐛 Troubleshooting boot :

Si tu arrives direct en TTY sans Ly :

```bash
# 1. Vérifie que Ly est installé
pacman -Q ly

# 2. Vérifie les logs
sudo journalctl -u ly

# 3. Lance Hyprland manuellement pour tester
Hyprland

# 4. Si ça marche, le problème vient de Ly
sudo systemctl enable ly --force
sudo reboot
```

## 🚀 Lancement manuel si besoin :

```bash
# Depuis TTY, lance directement Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=Hyprland
exec Hyprland
```
