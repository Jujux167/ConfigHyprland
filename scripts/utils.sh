#!/bin/bash

# ========================================
# Script utilitaires - HyDE Style
# ========================================

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Fonction d'affichage stylé
print_step() {
    echo -e "${PURPLE}=== ${CYAN}[$1]${NC} ${GREEN}$2${NC} ${PURPLE}===${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo -e "${CYAN}"
    cat << "EOF"
    ██╗  ██╗██╗   ██╗██████╗ ██████╗ 
    ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗
    ███████║ ╚████╔╝ ██████╔╝██████╔╝
    ██╔══██║  ╚██╔╝  ██╔══██╗██╔══██╗
    ██║  ██║   ██║   ██║  ██║██║  ██║
    ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝
                                     
    Configuration Hyprland Premium
EOF
    echo -e "${NC}"
}

print_conclusion() {
    print_success "🎉 Installation Hyprland terminée !"
    echo -e "${CYAN}"
    cat << "EOF"
┌─────────────────────────────────────────┐
│        🚀 Configuration Hyprland        │
│         Installation réussie !          │
└─────────────────────────────────────────┘
EOF
    echo -e "${NC}"

    echo -e "${GREEN}📋 Prochaines étapes :${NC}"
    echo -e "  ${BLUE}1.${NC} Redémarre ton système : ${YELLOW}sudo reboot${NC}"
    echo -e "  ${BLUE}2.${NC} Connecte-toi via Ly (login manager)"
    echo -e "  ${BLUE}3.${NC} Lance Hyprland et profite !"
    echo ""
    echo -e "${GREEN}⌨️  Raccourcis principaux :${NC}"
    echo -e "  ${PURPLE}SUPER + A${NC} : Terminal"
    echo -e "  ${PURPLE}SUPER + R${NC} : Menu applications"
    echo -e "  ${PURPLE}SUPER + E${NC} : Explorateur"
    echo -e "  ${PURPLE}SUPER + L${NC} : Verrouiller"
    echo ""
    echo -e "${GREEN}🎨 Thème :${NC} Catppuccin Mocha avec effets premium"
    echo -e "${GREEN}🔧 Config :${NC} ~/.config/hypr/"
    echo ""
    print_success "Bienvenue dans ton nouvel environnement Hyprland ! ✨"
}

update_mirrors() {
    print_step "0" "Mise à jour des miroirs et du système"
    pacman -Sy --noconfirm reflector
    reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    pacman -Syu --noconfirm
}

install_yay() {
    print_step "2" "Installation de yay (AUR helper)"
    sudo -u $USERNAME bash <<EOF
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si --noconfirm
EOF
}

cleanup_system() {
    print_step "17" "Nettoyage du système"
    pacman -Rns --noconfirm $(pacman -Qdtq) 2>/dev/null || true
    
    print_step "18" "Nettoyage du cache"
    pacman -Scc --noconfirm
}
