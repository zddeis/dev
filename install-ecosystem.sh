#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────
# Hyprland Ecosystem — Fresh Install Script
# Run this on a fresh Arch Linux install.
# ──────────────────────────────────────────────

RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'
log()  { echo -e "${GREEN}[+]${NC} $*"; }
warn() { echo -e "${RED}[!]${NC} $*"; }
info() { echo -e "${CYAN}[*]${NC} $*"; }

# ── Ensure running as a regular user ──
if [[ $EUID -eq 0 ]]; then
  warn "Do not run as root. Run as a normal user with sudo access."
  exit 1
fi

# ── Helper: install package if missing ──
ensure_pkg() {
  if ! pacman -Qi "$1" &>/dev/null; then
    info "Installing: $1"
    sudo pacman -S --noconfirm "$1"
  fi
}

ensure_aur() {
  if ! yay -Qi "$1" &>/dev/null; then
    info "Installing (AUR): $1"
    yay -S --noconfirm "$1"
  fi
}

# ═══════════════════════════════════════════════
# 1. BASE SYSTEM & PACKAGE MANAGERS
# ═══════════════════════════════════════════════

log "Updating system and installing base packages..."
sudo pacman -Syu --noconfirm

# Essential build tools
ensure_pkg base-devel
ensure_pkg git
ensure_pkg curl
ensure_pkg wget

# ── yay (AUR helper) ──
if ! command -v yay &>/dev/null; then
  log "Installing yay (AUR helper)..."
  TMPDIR="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$TMPDIR/yay"
  cd "$TMPDIR/yay"
  makepkg -si --noconfirm
  rm -rf "$TMPDIR/yay"
fi

# ── Rust / Cargo ──
if ! command -v rustup &>/dev/null; then
  log "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
source "$HOME/.cargo/env"

# ═══════════════════════════════════════════════
# 2. HYPRLAND CORE
# ═══════════════════════════════════════════════

log "Installing Hyprland and core plugins..."
ensure_pkg hyprland
ensure_pkg hyprpaper
ensure_pkg hyprlock
ensure_pkg hyprpicker
ensure_pkg hyprshot

# AUR Hyprland tools
ensure_aur hyprshade
ensure_aur hyprshutdown-git

# xdg-desktop-portal
ensure_aur xdg-desktop-portal-hyprland

# ═══════════════════════════════════════════════
# 3. SHELL & TERMINAL
# ═══════════════════════════════════════════════

log "Installing shell & terminal..."
ensure_pkg zsh
ensure_aur ghostty

# ── oh-my-zsh ──
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
install_zsh_plugin() {
  local name="$1" url="$2"
  local dir="$ZSH_CUSTOM/plugins/$name"
  if [[ ! -d "$dir" ]]; then
    git clone --depth=1 "$url" "$dir"
  fi
}
install_zsh_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
install_zsh_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"
install_zsh_plugin "fast-syntax-highlighting" "https://github.com/zdharma-continuum/fast-syntax-highlighting"
install_zsh_plugin "zsh-autocomplete" "https://github.com/marlonrichert/zsh-autocomplete"

# ═══════════════════════════════════════════════
# 4. NOTIFICATIONS, LAUNCHERS & UI
# ═══════════════════════════════════════════════

log "Installing desktop UI components..."
ensure_pkg dunst        # notification daemon
ensure_pkg rofi         # launcher
ensure_pkg waybar       # status bar (common Hyprland companion)
ensure_pkg nautilus     # file manager
ensure_pkg pavucontrol  # audio mixer
ensure_pkg brightnessctl
ensure_pkg playerctl
ensure_pkg wireplumber
ensure_pkg iwgtk        # wifi manager
ensure_pkg btop         # system monitor

# AUR GUI apps
ensure_aur visual-studio-code-bin
ensure_aur neovim
ensure_aur discord
ensure_aur zen-browser-bin

# ── Vicinae (app switcher) ──
if ! command -v vicinae &>/dev/null; then
  log "Installing vicinae..."
  cargo install vicinae
fi

# ── Hyprshell (Rust-based launcher/overview) ──
if ! command -v hyprshell &>/dev/null; then
  log "Installing hyprshell..."
  cargo install hyprshell
fi

# ═══════════════════════════════════════════════
# 5. KEY REMAPPING
# ═══════════════════════════════════════════════

log "Installing xremap..."
ensure_aur xremap-x11-binary  # works on Wayland too

# ═══════════════════════════════════════════════
# 6. SCREENSHOT & MEDIA
# ═══════════════════════════════════════════════

ensure_pkg grim
ensure_pkg slurp
ensure_pkg xdg-utils

# ── mpvpaper (video wallpaper, commented in config but useful) ──
ensure_aur mpvpaper

# ═══════════════════════════════════════════════
# 8. NVIDIA DRIVERS (optional — uncomment if needed)
# ═══════════════════════════════════════════════

# info "Installing NVIDIA drivers..."
# ensure_pkg nvidia-dkms
# ensure_pkg nvidia-utils
# ensure_pkg libva-nvidia-driver

# ═══════════════════════════════════════════════
# 9. VENCORD (Discord mod for themes)
# ═══════════════════════════════════════════════

if [[ ! -d "$HOME/.config/Vencord" ]]; then
  log "Installing Vencord..."
  sh -c "$(curl -fsSL https://vencord.dev/install.sh)"
fi

# ── Vencord themes directory ──
mkdir -p "$HOME/.config/Vencord/themes"

# ═══════════════════════════════════════════════
# 10. OPENCODE
# ═══════════════════════════════════════════════

if [[ ! -f "$HOME/.opencode/bin/opencode" ]]; then
  log "Installing Opencode..."
  mkdir -p "$HOME/.opencode/bin"
  bash <(curl -fsSL https://opencode.ai/install.sh)
fi

# ═══════════════════════════════════════════════
# 11. KEYBOARD RGB UTILITY
# ═══════════════════════════════════════════════

if [[ ! -f /usr/local/bin/set-kbd-color ]]; then
  log "Installing set-kbd-color (keyboard RGB utility)..."
  sudo tee /usr/local/bin/set-kbd-color > /dev/null << 'KBDEOF'
#!/usr/bin/env bash
# Replace this with your actual keyboard RGB tool.
# Example using g810-led for Logitech:
#   g810-led --set-all "$1" "$2" "$3"
# Or using openrgb:
#   openrgb -d 0 --mode static --color "$1" "$2" "$3"
echo "set-kbd-color: replace this script with your actual keyboard command"
exit 1
KBDEOF
  sudo chmod +x /usr/local/bin/set-kbd-color
fi

# ═══════════════════════════════════════════════
# 12. SYMLINK / COPY CONFIGS
# ═══════════════════════════════════════════════

if [[ -x "$HOME/dev/runs/sync-configs.sh" ]]; then
  log "Syncing configuration files..."
  "$HOME/dev/runs/sync-configs.sh"
else
  warn "sync-configs.sh not found — you will need to copy configs manually."
  info "Configs are at: $HOME/dev/configs/"
  info "Run: $HOME/dev/runs/sync-configs.sh"
fi

# ═══════════════════════════════════════════════
# DONE
# ═══════════════════════════════════════════════

log "Installation complete!"
info "Reboot and select Hyprland from your display manager."
info "Or start it from tty with: Hyprland"
