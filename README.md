# skywalker-ubuntu-hyprland

Personal Hyprland dotfiles on Ubuntu 24.04 — built on top of [JaKooLit's Ubuntu-Hyprland](https://github.com/JaKooLit/Ubuntu-Hyprland).

## What's included

| Component | Description |
|-----------|-------------|
| **Waybar** | Flat pill layout — colors auto-update with wallpaper via wallust |
| **Wallust** | Templates for waybar, kitty, p10k, nvim, cava, rofi |
| **Neovim** | LazyVim + wallust colorscheme + SRE/SDE language support |
| **Kitty** | Wallust-themed, JetBrainsMono Nerd Font |
| **p10k** | Pill prompt with wallust hex colors |
| **Cava** | Wallust gradient colors |
| **Hyprland scripts** | Dual-monitor wallpaper, wallust reload pipeline |

## How it works

```
change wallpaper → swww → WallustSwww.sh → wallust run
                                         → regenerates color files for all apps
                                         → reloads waybar, kitty, nvim, cava live
```

Colors are driven entirely by the wallpaper. No manual theming needed.

## Prerequisites

1. [JaKooLit Ubuntu-Hyprland](https://github.com/JaKooLit/Ubuntu-Hyprland) base install
2. `nvim` (0.9+)
3. `kitty`
4. `wallust`
5. `swww`
6. `zsh` + `powerlevel10k`

## Install

```zsh
git clone https://github.com/yourusername/skywalker-ubuntu-hyprland.git
cd skywalker-ubuntu-hyprland
zsh install.zsh
```

The install script will:
- Symlink all config files to their correct locations (existing files are backed up)
- Run wallust to generate color files from the current wallpaper
- Install lazygit if missing
- Install Python tools (ruff, black, isort, yamllint)

After install:
- Open `nvim` — LazyVim and Mason will auto-install plugins and LSP servers
- Reload waybar: `killall -SIGUSR2 waybar`
- Restart your zsh session for p10k colors

## Neovim language support

Python, Go, TypeScript, Rust, Bash, Docker, YAML, Terraform, JSON, TOML, Markdown, Ansible, SQL

## File structure

```
├── install.zsh
├── config/
│   ├── waybar/
│   │   ├── style/wallust-pills.css     ← flat pill layout (structure only)
│   │   ├── configs/wallust-top         ← top bar module layout
│   │   └── wallust/colors-waybar.css   ← auto-generated colors (starter values)
│   ├── wallust/
│   │   ├── wallust.toml                ← template registry
│   │   ├── templates/                  ← color templates for all apps
│   │   └── p10k-colors.zsh             ← generated p10k hex colors
│   ├── kitty/kitty.conf
│   ├── nvim/
│   │   ├── colors/wallust.lua          ← wallust colorscheme
│   │   └── lua/plugins/
│   │       ├── colorscheme.lua
│   │       └── lang.lua                ← SRE/SDE language extras
│   ├── hypr/
│   │   ├── scripts/WallustSwww.sh      ← wallpaper + color reload pipeline
│   │   └── UserScripts/WallpaperSelect.sh
│   └── cava/config
└── home/
    └── .p10k.zsh
```
