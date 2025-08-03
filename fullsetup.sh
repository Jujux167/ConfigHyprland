#!/bin/bash

# ======================== CONFIG ========================
USERNAME=$(logname)
HOME_DIR="/home/$USERNAME"
# ========================================================

# 0. Vérification des droits
if [ "$EUID" -ne 0 ]; then
  echo "❌ Lance ce script avec sudo ou en root."
  exit 1
fi

echo "=== [0] Mise à jour des miroirs et du système ==="
pacman -Sy --noconfirm reflector
reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syu --noconfirm

echo "=== [1] Outils de base & dev ==="
pacman -S --noconfirm base-devel git sudo curl wget unzip \
                      neovim tmux htop tree

echo "=== [2] AUR helper : yay ==="
sudo -u $USERNAME bash <<EOF
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si --noconfirm
EOF

echo "=== [3] Hyprland & modules ==="
pacman -S --noconfirm hyprland polkit \
    hyprpaper hyprpicker hypridle hyprlock hyprcursor \
    xdg-desktop-portal-hyprland hyprpolkitagent hyprsunset

echo "=== [4] Waybar + config complète ==="
pacman -S --noconfirm waybar
mkdir -p $HOME_DIR/.config/waybar
cat > $HOME_DIR/.config/waybar/config <<'EOF'
{
    "layer": "top",
    "position": "top",
    "height": 32,
    "modules-left": ["hyprland/workspaces", "hyprland/mode"],
    "modules-center": ["clock"],
    "modules-right": ["custom/gpu", "cpu", "memory", "temperature", "pulseaudio", "network", "battery", "tray"],
    
    "hyprland/workspaces": {
        "disable-scroll": true,
        "all-outputs": true,
        "format": "{icon}",
        "format-icons": {
            "1": "󰈹",
            "2": "",
            "3": "",
            "4": "",
            "5": "󰊴",
            "urgent": "",
            "focused": "",
            "default": ""
        }
    },
    
    "clock": {
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "format": "{:%H:%M}",
        "format-alt": "{:%Y-%m-%d}"
    },
    
    "cpu": {
        "format": " {usage}%",
        "tooltip": true,
        "interval": 1
    },
    
    "memory": {
        "format": " {used:0.1f}G",
        "tooltip": true
    },
    
    "temperature": {
        "critical-threshold": 80,
        "format": "{icon} {temperatureC}°C",
        "format-icons": ["", "", "", "", ""]
    },
    
    "custom/gpu": {
        "exec": "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -1",
        "format": "󰾲 {}%",
        "interval": 3,
        "tooltip": false
    },
    
    "battery": {
        "states": {
            "warning": 30,
            "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": "󰂄 {capacity}%",
        "format-plugged": "󰂄 {capacity}%",
        "format-alt": "{time} {icon}",
        "format-icons": ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    },
    
    "network": {
        "format-wifi": "󰤨 {essid}",
        "format-ethernet": "󰈀 Connected",
        "format-linked": "󰈀 {ifname} (No IP)",
        "format-disconnected": "󰤮 Disconnected",
        "format-alt": "{ifname}: {ipaddr}/{cidr}",
        "tooltip-format": "{ifname} via {gwaddr}"
    },
    
    "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-bluetooth": "{icon}󰂯 {volume}%",
        "format-bluetooth-muted": "󰝟󰂯",
        "format-muted": "󰝟",
        "format-source": "󰍬 {volume}%",
        "format-source-muted": "󰍭",
        "format-icons": {
            "headphone": "󰋋",
            "hands-free": "󰋎",
            "headset": "󰋎",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["󰕿", "󰖀", "󰕾"]
        },
        "on-click": "pavucontrol"
    }
}
EOF

cat > $HOME_DIR/.config/waybar/style.css <<'EOF'
* {
    font-family: 'FiraCode Nerd Font';
    font-size: 13px;
    border: none;
    border-radius: 0;
    margin: 0;
    padding: 0;
}

window#waybar {
    background: rgba(30, 30, 46, 0.9);
    color: #cdd6f4;
    border-bottom: 2px solid #89b4fa;
}

#workspaces button {
    background: transparent;
    color: #6c7086;
    border-radius: 8px;
    margin: 2px;
    padding: 0 8px;
}

#workspaces button.active {
    background: #89b4fa;
    color: #1e1e2e;
}

#workspaces button:hover {
    background: #313244;
    color: #cdd6f4;
}

#clock {
    background: #fab387;
    color: #1e1e2e;
    padding: 0 12px;
    margin: 2px;
    border-radius: 8px;
    font-weight: bold;
}

#cpu {
    background: #a6e3a1;
    color: #1e1e2e;
    padding: 0 10px;
    margin: 2px;
    border-radius: 8px;
}

#memory {
    background: #f9e2af;
    color: #1e1e2e;
    padding: 0 10px;
    margin: 2px;
    border-radius: 8px;
}

#temperature {
    background: #f38ba8;
    color: #1e1e2e;
    padding: 0 10px;
    margin: 2px;
    border-radius: 8px;
}

#custom-gpu {
    background: #cba6f7;
    color: #1e1e2e;
    padding: 0 10px;
    margin: 2px;
    border-radius: 8px;
}

#pulseaudio {
    background: #89dceb;
    color: #1e1e2e;
    padding: 0 10px;
    margin: 2px;
    border-radius: 8px;
}

#network {
    background: #94e2d5;
    color: #1e1e2e;
    padding: 0 10px;
    margin: 2px;
    border-radius: 8px;
}

#battery {
    background: #b4befe;
    color: #1e1e2e;
    padding: 0 10px;
    margin: 2px;
    border-radius: 8px;
}

#tray {
    background: #585b70;
    padding: 0 8px;
    margin: 2px;
    border-radius: 8px;
}
EOF
chown -R $USERNAME: $HOME_DIR/.config/waybar

echo "=== [5] Terminal & explorateurs & lecteurs & outils système ==="
pacman -S --noconfirm kitty nnn thunar mpv \
                      grim slurp wl-clipboard \
                      brightnessctl playerctl \
                      firefox polkit-gnome imagemagick \
                      pavucontrol alacritty \
                      file-roller unrar p7zip \
                      neofetch btop \
                      vlc \
                      code

echo "=== [6] Audio : PipeWire ==="
pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse wireplumber

echo "=== [7] Réseau : Wi-Fi & Bluetooth ==="
pacman -S --noconfirm networkmanager network-manager-applet nm-connection-editor
systemctl enable --now NetworkManager

pacman -S --noconfirm bluez bluez-utils blueman
systemctl enable --now bluetooth

echo "=== [8] Batterie : TLP ==="
pacman -S --noconfirm tlp
systemctl enable --now tlp

echo "=== [9] Thèmes GTK & icônes & curseurs ==="
pacman -S --noconfirm arc-gtk-theme breeze-gtk materia-gtk-theme \
                      papirus-icon-theme \
                      bibata-cursor-theme \
                      qt5ct qt6ct \
                      lxappearance

echo "=== [10] Pilotes GPU NVIDIA RTX ==="
GPU=$(lspci | grep -E "VGA|3D")
if echo "$GPU" | grep -qi nvidia; then
  pacman -S --noconfirm nvidia nvidia-utils nvidia-settings libva-nvidia-driver \
                        nvtop nvidia-prime
elif echo "$GPU" | grep -qi intel; then
  pacman -S --noconfirm mesa libva-intel-driver intel-media-driver intel-gpu-tools
else
  pacman -S --noconfirm mesa
fi

echo "=== [11] Ly (login manager) ==="
pacman -S --noconfirm ly
systemctl enable --now ly.service

echo "=== [12] Rofi (launcher) ==="
pacman -S --noconfirm rofi
mkdir -p $HOME_DIR/.config/rofi
cat > $HOME_DIR/.config/rofi/config.rasi <<'EOF'
configuration {
  modi: "drun,run,window";
  show-icons: true;
  font: "Monospace 12";
}
EOF
chown -R $USERNAME: $HOME_DIR/.config/rofi

echo "=== [13] Config Hyprland complète avec clavier FR ==="
mkdir -p $HOME_DIR/.config/hypr
cat > $HOME_DIR/.config/hypr/hyprland.conf <<'EOF'
# ========================================
# Configuration Hyprland - Clavier FR
# ========================================

# Moniteurs
monitor=,preferred,auto,1

# Variables d'environnement
env = XCURSOR_SIZE,24
env = QT_QPA_PLATFORMTHEME,qt6ct
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland

# Variables pour applications
$terminal = kitty
$fileManager = thunar
$menu = rofi -show drun
$browser = firefox

# Démarrage automatique
exec-once = waybar &
exec-once = hyprpaper &
exec-once = hypridle &
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
exec-once = nm-applet &
exec-once = blueman-applet &

# Configuration du clavier français
input {
    kb_layout = fr
    kb_variant = 
    kb_model = 
    kb_options = 
    kb_rules = 

    follow_mouse = 1
    sensitivity = 0
    
    touchpad {
        natural_scroll = yes
        tap-to-click = yes
        scroll_factor = 0.5
    }
}

# Apparence générale
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
    layout = dwindle
    allow_tearing = false
}

# Décoration des fenêtres
decoration {
    rounding = 10
    
    blur {
        enabled = true
        size = 3
        passes = 1
        vibrancy = 0.1696
    }
    
    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

# Animations
animations {
    enabled = yes
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# Layout dwindle
dwindle {
    pseudotile = yes
    preserve_split = yes
}

# Layout master
master {
    new_is_master = true
}

# Gestes
gestures {
    workspace_swipe = on
}

# Divers
misc {
    force_default_wallpaper = 0
    disable_hyprland_logo = true
}

# ========================================
# RACCOURCIS CLAVIER (Layout FR)
# ========================================

# Applications principales
bind = SUPER, ampersand, workspace, 1        # &
bind = SUPER, eacute, workspace, 2           # é
bind = SUPER, quotedbl, workspace, 3         # "
bind = SUPER, apostrophe, workspace, 4       # '
bind = SUPER, parenleft, workspace, 5        # (
bind = SUPER, minus, workspace, 6            # -
bind = SUPER, egrave, workspace, 7           # è
bind = SUPER, underscore, workspace, 8       # _
bind = SUPER, ccedilla, workspace, 9         # ç
bind = SUPER, agrave, workspace, 10          # à

# Déplacer vers workspace (avec Shift)
bind = SUPER SHIFT, ampersand, movetoworkspace, 1
bind = SUPER SHIFT, eacute, movetoworkspace, 2
bind = SUPER SHIFT, quotedbl, movetoworkspace, 3
bind = SUPER SHIFT, apostrophe, movetoworkspace, 4
bind = SUPER SHIFT, parenleft, movetoworkspace, 5
bind = SUPER SHIFT, minus, movetoworkspace, 6
bind = SUPER SHIFT, egrave, movetoworkspace, 7
bind = SUPER SHIFT, underscore, movetoworkspace, 8
bind = SUPER SHIFT, ccedilla, movetoworkspace, 9
bind = SUPER SHIFT, agrave, movetoworkspace, 10

# Applications et contrôles
bind = SUPER, A, exec, $terminal                    # Terminal
bind = SUPER, C, killactive,                        # Fermer fenêtre
bind = SUPER, M, exit,                              # Quitter Hyprland
bind = SUPER, E, exec, $fileManager                 # Explorateur
bind = SUPER, V, togglefloating,                    # Mode flottant
bind = SUPER, R, exec, $menu                        # Menu applications
bind = SUPER, P, pseudo,                            # Pseudo tile
bind = SUPER, J, togglesplit,                       # Changer split
bind = SUPER, F, fullscreen,                        # Plein écran
bind = SUPER, B, exec, $browser                     # Navigateur

# Navigation dans les fenêtres
bind = SUPER, Left, movefocus, l
bind = SUPER, Right, movefocus, r
bind = SUPER, Up, movefocus, u
bind = SUPER, Down, movefocus, d

# Navigation avec hjkl (vim-like)
bind = SUPER, H, movefocus, l
bind = SUPER, L, movefocus, r
bind = SUPER, K, movefocus, u
bind = SUPER, J, movefocus, d

# Déplacer les fenêtres
bind = SUPER SHIFT, Left, movewindow, l
bind = SUPER SHIFT, Right, movewindow, r
bind = SUPER SHIFT, Up, movewindow, u
bind = SUPER SHIFT, Down, movewindow, d

# Redimensionner les fenêtres
bind = SUPER CTRL, Left, resizeactive, -20 0
bind = SUPER CTRL, Right, resizeactive, 20 0
bind = SUPER CTRL, Up, resizeactive, 0 -20
bind = SUPER CTRL, Down, resizeactive, 0 20

# Contrôles multimédia
bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bind = , XF86AudioPlay, exec, playerctl play-pause
bind = , XF86AudioPause, exec, playerctl play-pause
bind = , XF86AudioNext, exec, playerctl next
bind = , XF86AudioPrev, exec, playerctl previous

# Contrôles de luminosité
bind = , XF86MonBrightnessUp, exec, brightnessctl set 10%+
bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%-

# Captures d'écran
bind = SUPER, Print, exec, grim -g "$(slurp)" - | wl-copy
bind = , Print, exec, grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png
bind = SUPER SHIFT, S, exec, grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png

# Verrouillage d'écran
bind = SUPER, L, exec, hyprlock

# Mode redimensionnement avec Alt+R
bind = ALT, R, submap, resize
submap = resize
bind = , Right, resizeactive, 10 0
bind = , Left, resizeactive, -10 0
bind = , Up, resizeactive, 0 -10
bind = , Down, resizeactive, 0 10
bind = , escape, submap, reset
submap = reset

# Scrolling pour changer de workspace
bind = SUPER, mouse_down, workspace, e+1
bind = SUPER, mouse_up, workspace, e-1

# Déplacer/redimensionner avec la souris
bindm = SUPER, mouse:272, movewindow
bindm = SUPER, mouse:273, resizewindow

# ========================================
# RÈGLES DE FENÊTRES
# ========================================

# Firefox
windowrulev2 = float, class:^(firefox)$, title:^(Picture-in-Picture)$
windowrulev2 = pin, class:^(firefox)$, title:^(Picture-in-Picture)$

# Pavucontrol
windowrulev2 = float, class:^(pavucontrol)$
windowrulev2 = size 800 600, class:^(pavucontrol)$

# File manager
windowrulev2 = float, class:^(thunar)$, title:^(File Operation Progress)$

# Rofi
windowrulev2 = float, class:^(Rofi)$
windowrulev2 = dimaround, class:^(Rofi)$

# Applications système
windowrulev2 = float, class:^(nm-connection-editor)$
windowrulev2 = float, class:^(blueman-manager)$
windowrulev2 = float, class:^(gnome-calculator)$

# ========================================
# WORKSPACES SPÉCIAUX
# ========================================

# Scratchpad
bind = SUPER, S, togglespecialworkspace, magic
bind = SUPER SHIFT, S, movetoworkspace, special:magic
EOF
chown -R $USERNAME: $HOME_DIR/.config/hypr

echo "=== [13b] Config Hyprpaper pour fond d'écran ==="
cat > $HOME_DIR/.config/hypr/hyprpaper.conf <<'EOF'
preload = ~/Pictures/wallpaper.jpg
wallpaper = ,~/Pictures/wallpaper.jpg
splash = false
ipc = on
EOF

echo "=== [13c] Création dossier Pictures et fond d'écran par défaut ==="
mkdir -p $HOME_DIR/Pictures
# Télécharge un fond d'écran par défaut si disponible
curl -L -o $HOME_DIR/Pictures/wallpaper.jpg "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1920&h=1080&fit=crop&crop=entropy&auto=format&q=80" 2>/dev/null || {
    # Si le téléchargement échoue, crée une couleur unie
    convert -size 1920x1080 xc:'#2e3440' $HOME_DIR/Pictures/wallpaper.jpg 2>/dev/null || {
        echo "⚠️  Impossible de créer le fond d'écran. Installe imagemagick si tu veux une couleur par défaut."
    }
}
chown -R $USERNAME: $HOME_DIR/Pictures

echo "=== [14] .xinitrc pour startx ==="
cat > $HOME_DIR/.xinitrc <<'EOF'
# Lance Ly si disponible, sinon Hyprland direct
if command -v ly >/dev/null 2>&1; then
  exec ly
else
  exec Hyprland
fi
EOF
chown $USERNAME: $HOME_DIR/.xinitrc


echo "=== [15] Installation des Nerd Fonts monospace ==="
pacman -S --noconfirm ttf-nerd-fonts-symbols-mono ttf-firacode-nerd

echo "=== [15b] Paquets AUR pour le confort ==="
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

echo "=== [16] Configuration Kitty stylée ==="
mkdir -p $HOME_DIR/.config/kitty
cat > $HOME_DIR/.config/kitty/kitty.conf <<'EOF'
# Police et apparence
font_family      FiraCode Nerd Font
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size 12.0

# Curseur
cursor_shape block
cursor_blink_interval 0.5
cursor_stop_blinking_after 15.0

# Scrollback
scrollback_lines 10000
scrollback_pager less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER

# Souris
mouse_hide_wait 3.0
url_color #89b4fa
url_style curly

# Performance
repaint_delay 10
input_delay 3
sync_to_monitor yes

# Thème Catppuccin Mocha
foreground              #CDD6F4
background              #1E1E2E
selection_foreground    #1E1E2E
selection_background    #F5E0DC

# Couleurs du curseur
cursor                  #F5E0DC
cursor_text_color       #1E1E2E

# Couleurs des URL
url_color               #F5E0DC

# Couleurs des bordures
active_border_color     #B4BEFE
inactive_border_color   #6C7086
bell_border_color       #F9E2AF

# Couleurs des onglets
active_tab_foreground   #11111B
active_tab_background   #CBA6F7
inactive_tab_foreground #CDD6F4
inactive_tab_background #181825
tab_bar_background      #11111B

# Couleurs normales
color0 #45475A
color1 #F38BA8
color2 #A6E3A1
color3 #F9E2AF
color4 #89B4FA
color5 #F5C2E7
color6 #94E2D5
color7 #BAC2DE

# Couleurs claires
color8  #585B70
color9  #F38BA8
color10 #A6E3A1
color11 #F9E2AF
color12 #89B4FA
color13 #F5C2E7
color14 #94E2D5
color15 #A6ADC8

# Raccourcis
map ctrl+shift+c copy_to_clipboard
map ctrl+shift+v paste_from_clipboard
map ctrl+shift+t new_tab
map ctrl+shift+q close_tab
map ctrl+shift+n new_window
map ctrl+shift+enter new_window
EOF
chown -R $USERNAME: $HOME_DIR/.config/kitty

echo "=== [17] Nettoyage des paquets inutiles ==="
pacman -Rns --noconfirm $(pacman -Qdtq)
echo "=== [18] Nettoyage du cache des paquets ==="
pacman -Scc --noconfirm

echo "✅ Tout est installé et configuré ! Redémarre et connecte-toi via Ly, ou lance 'startx' pour démarrer Hyprland."
