#!/bin/bash

# ========================================
# Configuration Hyprland - Structure Modulaire
# Installation organisée par catégories
# ========================================

# Récupération du répertoire du script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Variables globales
USERNAME=$(logname)
HOME_DIR="/home/$USERNAME"

# Vérification des droits root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Lance ce script avec sudo ou en root."
  exit 1
fi

# Importation des modules
source "$SCRIPT_DIR/scripts/utils.sh"
source "$SCRIPT_DIR/scripts/install-packages.sh"
source "$SCRIPT_DIR/scripts/setup-configs.sh"

# ========================================
# FONCTION PRINCIPALE
# ========================================

main() {
    # Header stylé
    print_header

    # Configuration Pacman avant tout
    configure_pacman

    # Étapes d'installation modulaires
    print_step "1" "Préparation du système"
    update_mirrors

    print_step "2" "Installation des paquets de base"
    install_base_packages

    print_step "3" "Installation d'Hyprland et composants"
    install_hyprland

    print_step "4" "Installation de Waybar"
    install_waybar

    print_step "5" "Installation des applications"
    install_apps

    print_step "6" "Installation audio PipeWire"
    install_audio

    print_step "7" "Installation réseau & Bluetooth"
    install_network

    print_step "8" "Installation gestion batterie"
    install_power

    print_step "9" "Installation thèmes & icônes"
    install_themes

    print_step "10" "Installation pilotes GPU"
    install_gpu_drivers

    print_step "11" "Installation Ly (login manager)"
    install_login_manager

    print_step "12" "Installation Rofi"
    install_rofi

    print_step "13" "Installation de l'AUR helper (yay)"
    install_yay

    print_step "14" "Installation des polices"
    install_fonts

    print_step "15" "Installation des paquets AUR"
    install_aur_packages

    print_step "16" "Configuration d'Hyprland"
    setup_hyprland_config

    print_step "17" "Configuration de Waybar"
    setup_waybar_config

    print_step "18" "Configuration de Rofi"
    setup_rofi_config

    print_step "19" "Configuration de Kitty"
    setup_kitty_config

    print_step "20" "Configuration d'Hyprlock"
    setup_hyprlock

    print_step "21" "Configuration des wallpapers"
    setup_wallpaper

    print_step "22" "Activation des services"
    enable_services

    print_step "23" "Configuration finale"
    setup_xinitrc

    print_step "24" "Nettoyage du système"
    cleanup_system

    # Conclusion stylée
    print_conclusion
}

# Services à activer
enable_services() {
    systemctl enable NetworkManager
    systemctl enable bluetooth
    systemctl enable ly
    systemctl enable tlp
    
    # Services utilisateur
    sudo -u $USERNAME systemctl --user enable pipewire
    sudo -u $USERNAME systemctl --user enable wireplumber
    
    print_success "Services activés"
}

# ========================================
# LANCEMENT DU SCRIPT
# ========================================

# Vérification de l'existence des modules
if [[ ! -f "$SCRIPT_DIR/scripts/utils.sh" ]] || 
   [[ ! -f "$SCRIPT_DIR/scripts/install-packages.sh" ]] || 
   [[ ! -f "$SCRIPT_DIR/scripts/setup-configs.sh" ]]; then
    echo "❌ Modules manquants. Assure-toi d'avoir la structure complète :"
    echo "   - scripts/utils.sh"
    echo "   - scripts/install-packages.sh" 
    echo "   - scripts/setup-configs.sh"
    echo "   - configs/"
    exit 1
fi

# Lancement de l'installation
main "$@"
