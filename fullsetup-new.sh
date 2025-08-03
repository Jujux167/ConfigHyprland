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
    install_hyprland_packages

    print_step "4" "Installation des thèmes et icônes"
    install_theme_packages

    print_step "5" "Installation des applications"
    install_applications

    print_step "6" "Installation des drivers NVIDIA"
    install_gpu_packages

    print_step "7" "Installation de l'AUR helper"
    install_yay

    print_step "8" "Installation des paquets AUR"
    install_aur_packages

    print_step "9" "Configuration d'Hyprland"
    setup_hyprland_config

    print_step "10" "Configuration de Waybar"
    setup_waybar_config

    print_step "11" "Configuration de Rofi"
    setup_rofi_config

    print_step "12" "Configuration de Kitty"
    setup_kitty_config

    print_step "13" "Configuration d'Hyprlock"
    setup_hyprlock

    print_step "14" "Configuration des wallpapers"
    setup_wallpaper

    print_step "15" "Activation des services"
    enable_services

    print_step "16" "Configuration finale"
    setup_xinitrc

    print_step "17" "Nettoyage du système"
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
