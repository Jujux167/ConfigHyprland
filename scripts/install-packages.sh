#!/bin/bash

# ========================================
# Script d'installation des paquets
# ========================================

# Paquets ABSOLUMENT NÉCESSAIRES avant ce script :
# pacman -S base-devel git sudo

# Configuration de Pacman avec couleurs et animations
configure_pacman() {
    print_step "0" "Configuration de Pacman avec couleurs"
    
    # Sauvegarde du fichier original
    cp /etc/pacman.conf /etc/pacman.conf.backup
    
    # Active les couleurs et les animations
    sed -i 's/#Color/Color/' /etc/pacman.conf
    sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
    
    # Ajoute ILoveCandy pour l'animation Pac-Man
    if ! grep -q "ILoveCandy" /etc/pacman.conf; then
        sed -i '/^#VerbosePkgLists/a ILoveCandy' /etc/pacman.conf
    fi
    
    print_success "Pacman configuré avec couleurs et animation Pac-Man ! 🟡"
}

install_base_packages() {
    print_step "1" "Installation des paquets de base"
    # Le script s'occupe du reste automatiquement
    pacman -S --noconfirm --needed curl wget unzip \
                                   neovim tmux htop tree reflector
}

install_hyprland() {
    print_step "3" "Installation Hyprland & modules"
    pacman -S --noconfirm hyprland polkit \
        hyprpaper hyprpicker hypridle hyprlock hyprcursor \
        xdg-desktop-portal-hyprland hyprpolkitagent hyprsunset
}

install_waybar() {
    print_step "4" "Installation Waybar"
    pacman -S --noconfirm waybar
}

install_apps() {
    print_step "5" "Installation des applications"
    pacman -S --noconfirm kitty nnn thunar mpv \
                          grim slurp wl-clipboard \
                          brightnessctl playerctl \
                          firefox polkit-gnome imagemagick \
                          pavucontrol alacritty \
                          file-roller unrar p7zip \
                          neofetch btop \
                          vlc \
                          code
}

install_audio() {
    print_step "6" "Installation PipeWire"
    pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse wireplumber
}

install_network() {
    print_step "7" "Installation réseau & Bluetooth"
    pacman -S --noconfirm networkmanager network-manager-applet nm-connection-editor
    systemctl enable --now NetworkManager

    pacman -S --noconfirm bluez bluez-utils blueman
    systemctl enable --now bluetooth
}

install_power() {
    print_step "8" "Installation gestion batterie"
    pacman -S --noconfirm tlp
    systemctl enable --now tlp
}

install_themes() {
    print_step "9" "Installation thèmes & icônes"
    pacman -S --noconfirm arc-gtk-theme breeze-gtk materia-gtk-theme \
                          papirus-icon-theme \
                          bibata-cursor-theme \
                          qt5ct qt6ct \
                          lxappearance
}

install_gpu_drivers() {
    print_step "10" "Installation pilotes GPU"
    GPU=$(lspci | grep -E "VGA|3D")
    if echo "$GPU" | grep -qi nvidia; then
        pacman -S --noconfirm nvidia nvidia-utils nvidia-settings libva-nvidia-driver \
                            nvtop nvidia-prime
    elif echo "$GPU" | grep -qi intel; then
        pacman -S --noconfirm mesa libva-intel-driver intel-media-driver intel-gpu-tools
    else
        pacman -S --noconfirm mesa
    fi
}

install_login_manager() {
    print_step "11" "Installation Ly (login manager)"
    pacman -S --noconfirm ly
    systemctl enable --now ly.service
}

install_rofi() {
    print_step "12" "Installation Rofi"
    pacman -S --noconfirm rofi
}

install_fonts() {
    print_step "15" "Installation Nerd Fonts"
    pacman -S --noconfirm ttf-nerd-fonts-symbols-mono ttf-firacode-nerd
}

install_aur_packages() {
    print_step "15b" "Installation paquets AUR"
    sudo -u $USERNAME bash <<EOF
yay -S --noconfirm --needed \
    visual-studio-code-bin \
    google-chrome \
    spotify \
    nerd-fonts-fira-code \
    bibata-cursor-theme \
    whitesur-gtk-theme \
    tela-icon-theme
EOF
}
