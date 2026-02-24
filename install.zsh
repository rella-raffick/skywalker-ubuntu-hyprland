#!/usr/bin/env zsh
# skywalker-ubuntu-hyprland dotfiles installer
# Symlinks configs to their correct locations
#
# Prerequisites:
#   - JaKooLit Hyprland setup (https://github.com/JaKooLit/Ubuntu-Hyprland)
#   - nvim, kitty, wallust, swww already installed

set -euo pipefail

DOTFILES="${0:A:h}"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

info()  { print -P "%F{cyan}[info]%f  $*" }
ok()    { print -P "%F{green}[ok]%f    $*" }
warn()  { print -P "%F{yellow}[warn]%f  $*" }

link() {
  local src="$DOTFILES/$1"
  local dst="$2"
  mkdir -p "${dst:h}"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    mkdir -p "$BACKUP"
    cp -r "$dst" "$BACKUP/"
    warn "Backed up: $dst"
  fi
  ln -sf "$src" "$dst"
  ok "Linked: $dst"
}

info "Installing dotfiles from $DOTFILES"
info "Backups → $BACKUP"
echo

# ── Waybar ─────────────────────────────────────────────────────────────
link "config/waybar/style/wallust-pills.css"     "$HOME/.config/waybar/style/wallust-pills.css"
link "config/waybar/configs/wallust-top"         "$HOME/.config/waybar/configs/wallust-top"
link "config/waybar/wallust/colors-waybar.css"   "$HOME/.config/waybar/wallust/colors-waybar.css"
# Set as active style and layout
ln -sf "$HOME/.config/waybar/style/wallust-pills.css" "$HOME/.config/waybar/style.css"
ln -sf "$HOME/.config/waybar/configs/wallust-top"     "$HOME/.config/waybar/config"
ok "Waybar style and layout activated"

# ── Wallust ────────────────────────────────────────────────────────────
link "config/wallust/wallust.toml"                     "$HOME/.config/wallust/wallust.toml"
link "config/wallust/templates/colors-nvim.lua"        "$HOME/.config/wallust/templates/colors-nvim.lua"
link "config/wallust/templates/colors-p10k.zsh"        "$HOME/.config/wallust/templates/colors-p10k.zsh"
link "config/wallust/templates/colors-kitty.conf"      "$HOME/.config/wallust/templates/colors-kitty.conf"
link "config/wallust/p10k-colors.zsh"                  "$HOME/.config/wallust/p10k-colors.zsh"

# ── Kitty ──────────────────────────────────────────────────────────────
link "config/kitty/kitty.conf"                         "$HOME/.config/kitty/kitty.conf"

# ── Neovim ─────────────────────────────────────────────────────────────
link "config/nvim/init.lua"                            "$HOME/.config/nvim/init.lua"
link "config/nvim/lazyvim.json"                        "$HOME/.config/nvim/lazyvim.json"
link "config/nvim/stylua.toml"                         "$HOME/.config/nvim/stylua.toml"
link "config/nvim/lazy-lock.json"                      "$HOME/.config/nvim/lazy-lock.json"
link "config/nvim/colors/wallust.lua"                  "$HOME/.config/nvim/colors/wallust.lua"
link "config/nvim/lua/colors/wallust-colors.lua"       "$HOME/.config/nvim/lua/colors/wallust-colors.lua"
link "config/nvim/lua/plugins/colorscheme.lua"         "$HOME/.config/nvim/lua/plugins/colorscheme.lua"
link "config/nvim/lua/plugins/lang.lua"                "$HOME/.config/nvim/lua/plugins/lang.lua"

# ── Hyprland scripts + lock ────────────────────────────────────────────
link "config/hypr/scripts/WallustSwww.sh"              "$HOME/.config/hypr/scripts/WallustSwww.sh"
link "config/hypr/UserScripts/WallpaperSelect.sh"      "$HOME/.config/hypr/UserScripts/WallpaperSelect.sh"
link "config/hypr/hyprlock.conf"                       "$HOME/.config/hypr/hyprlock.conf"

# ── Wlogout ────────────────────────────────────────────────────────────
link "config/wlogout/style.css"                        "$HOME/.config/wlogout/style.css"
link "config/wlogout/layout"                           "$HOME/.config/wlogout/layout"

# ── Cava ───────────────────────────────────────────────────────────────
link "config/cava/config"                              "$HOME/.config/cava/config"

# ── Shell ──────────────────────────────────────────────────────────────
link "home/.p10k.zsh"                                  "$HOME/.p10k.zsh"

echo
info "Running wallust to regenerate color files..."
if command -v wallust >/dev/null && command -v swww >/dev/null; then
  WALLPAPER=$(swww query 2>/dev/null | awk '/image:/{sub(/^.*image: /,""); print; exit}')
  if [[ -n "$WALLPAPER" && -f "$WALLPAPER" ]]; then
    wallust run -s "$WALLPAPER"
    ok "Wallust colors regenerated"
  else
    warn "No active wallpaper found — set a wallpaper and wallust will auto-run"
  fi
else
  warn "wallust/swww not found — install them and run: wallust run <wallpaper>"
fi

echo
info "Installing lazygit..."
if command -v lazygit >/dev/null; then
  ok "lazygit already installed"
else
  LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d'"' -f4 | sed 's/v//')
  curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit /usr/local/bin
  ok "lazygit installed"
fi

echo
info "Installing Python tools..."
pip3 install --user --break-system-packages ruff black isort yamllint 2>/dev/null && ok "Python tools installed" || warn "pip3 install failed — install manually"

info "Installing Go tools..."
go install github.com/sqls-server/sqls@latest 2>/dev/null && ok "sqls installed" || warn "sqls install failed"

echo
ok "Done! Next steps:"
ok "  1. Open nvim — LazyVim + Mason will auto-install plugins/LSPs"
ok "  2. Reload waybar: killall -SIGUSR2 waybar"
ok "  3. Reload kitty: pkill -SIGUSR1 kitty"
ok "  4. Restart your zsh session for p10k colors"
