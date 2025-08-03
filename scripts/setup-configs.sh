#!/bin/bash

# ========================================
# Script de configuration des dotfiles
# ========================================

setup_hyprland_config() {
    print_step "13" "Configuration Hyprland"
    mkdir -p $HOME_DIR/.config/hypr
    
    # Copie des fichiers de config modulaires
    cp configs/hyprland.conf $HOME_DIR/.config/hypr/
    cp configs/keybinds.conf $HOME_DIR/.config/hypr/
    cp configs/windowrules.conf $HOME_DIR/.config/hypr/
    
    chown -R $USERNAME: $HOME_DIR/.config/hypr
}

setup_waybar_config() {
    print_step "4b" "Configuration Waybar"
    mkdir -p $HOME_DIR/.config/waybar
    
    cp configs/waybar.json $HOME_DIR/.config/waybar/config
    cp configs/waybar.css $HOME_DIR/.config/waybar/style.css
    
    chown -R $USERNAME: $HOME_DIR/.config/waybar
}

setup_rofi_config() {
    print_step "12b" "Configuration Rofi"
    mkdir -p $HOME_DIR/.config/rofi
    
    cp configs/rofi.rasi $HOME_DIR/.config/rofi/config.rasi
    
    chown -R $USERNAME: $HOME_DIR/.config/rofi
}

setup_hyprpaper() {
    print_step "13b" "Configuration Hyprpaper"
    cat > $HOME_DIR/.config/hypr/hyprpaper.conf <<'EOF'
preload = ~/Pictures/wallpaper.jpg
wallpaper = ,~/Pictures/wallpaper.jpg
splash = false
ipc = on
EOF
}

setup_hyprlock() {
    print_step "13c" "Configuration Hyprlock"
    cat > $HOME_DIR/.config/hypr/hyprlock.conf <<'EOF'
# Hyprlock Configuration - HyDE Style

general {
    disable_loading_bar = false
    grace = 2
    hide_cursor = true
    no_fade_in = false
}

background {
    monitor =
    path = ~/Pictures/wallpaper.jpg
    blur_passes = 3
    blur_size = 8
    noise = 0.0117
    contrast = 0.8916
    brightness = 0.8172
    vibrancy = 0.1696
    vibrancy_darkness = 0.0
}

input-field {
    monitor =
    size = 400, 60
    outline_thickness = 2
    dots_size = 0.33
    dots_spacing = 0.15
    dots_center = true
    dots_rounding = -1
    outer_color = rgb(cba6f7)
    inner_color = rgb(1e1e2e)
    font_color = rgb(cdd6f4)
    fade_on_empty = true
    fade_timeout = 1000
    placeholder_text = <i>Password...</i>
    hide_input = false
    rounding = 12
    check_color = rgb(a6e3a1)
    fail_color = rgb(f38ba8)
    fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
    fail_transition = 300
    capslock_color = rgb(f9e2af)
    numlock_color = -1
    bothlock_color = -1
    invert_numlock = false
    swap_font_color = false

    position = 0, -80
    halign = center
    valign = center
}

label {
    monitor =
    text = Hi there, $USER
    text_align = center
    color = rgb(cdd6f4)
    font_size = 25
    font_family = FiraCode Nerd Font
    rotate = 0

    position = 0, 80
    halign = center
    valign = center
}

label {
    monitor =
    text = $TIME
    text_align = center
    color = rgb(cdd6f4)
    font_size = 65
    font_family = FiraCode Nerd Font
    rotate = 0

    position = 0, 160
    halign = center
    valign = center
}

label {
    monitor =
    text = cmd[update:1000] echo "$(/bin/date +"%A, %d %B %Y")"
    text_align = center
    color = rgb(cdd6f4)
    font_size = 22
    font_family = FiraCode Nerd Font
    rotate = 0

    position = 0, 30
    halign = center
    valign = center
}
EOF
}

setup_kitty_config() {
    print_step "16" "Configuration Kitty"
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
}

setup_wallpaper() {
    print_step "13d" "Configuration fond d'écran"
    mkdir -p $HOME_DIR/Pictures
    
    # Télécharge un fond d'écran par défaut si disponible
    curl -L -o $HOME_DIR/Pictures/wallpaper.jpg "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1920&h=1080&fit=crop&crop=entropy&auto=format&q=80" 2>/dev/null || {
        # Si le téléchargement échoue, crée une couleur unie
        convert -size 1920x1080 xc:'#2e3440' $HOME_DIR/Pictures/wallpaper.jpg 2>/dev/null || {
            print_warning "Impossible de créer le fond d'écran. Installe imagemagick si tu veux une couleur par défaut."
        }
    }
    chown -R $USERNAME: $HOME_DIR/Pictures
}

setup_xinitrc() {
    print_step "14" "Configuration .xinitrc"
    cat > $HOME_DIR/.xinitrc <<'EOF'
# Lance Ly si disponible, sinon Hyprland direct
if command -v ly >/dev/null 2>&1; then
  exec ly
else
  exec Hyprland
fi
EOF
    chown $USERNAME: $HOME_DIR/.xinitrc
}
