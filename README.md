# 🏠 Dotfiles

> A collection of configuration files for a modern Linux development environment

This repository contains my personal dotfiles for various applications, optimized for a productive development workflow on Linux. The configurations are designed to work together seamlessly, providing a cohesive desktop experience using Wayland with Hyprland.

## 🚀 Quick Start

### Interactive Installation (Recommended)

The easiest way to install these dotfiles is using the interactive installation script:

```bash
# Clone the repository
git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the interactive installer
./install.sh
```

The installer will:
- Auto-detect your operating system
- Check dependencies for each configuration
- Allow you to select which configurations to install
- Only install configs with all dependencies satisfied

### Manual Installation

If you prefer manual control or want to install specific configurations:

1. **Install GNU Stow** (required for all methods)
   ```bash
   # On Arch Linux
   sudo pacman -S stow
   
   # On Ubuntu/Debian
   sudo apt install stow
   
   # On Fedora
   sudo dnf install stow
   ```

2. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

3. **Install configurations** (see Manual Installation section below)

## 📦 Configurations Overview

| Application | Description | Dependencies |
|-------------|-------------|--------------|
| **Hypr** | Wayland compositor with window management | `hyprland`, `waybar`, `hyprpaper`, `hyprlock`, `hyprshot`, `bluez-utils`, `wireplumber`, `wofi`, `kitty` |
| **Kitty** | GPU-accelerated terminal emulator | `kitty` |
| **Neovim** | Modern text editor with IDE features | `neovim` |
| **Tmux** | Terminal multiplexer for session management | `tmux` |
| **Waybar** | Highly customizable status bar for Wayland | `waybar` |
| **Wofi** | Application launcher and dmenu replacement | `wofi` |
| **Zsh** | Advanced shell with custom prompt and plugins | `zsh` |
| **VS Code** | Code editor extensions and settings | `code` |

## 🔧 Manual Installation

Use GNU Stow to symlink configurations to their appropriate locations:

### Test Installation (Dry Run)
Always test your installation first to see what will be linked:

```bash
# Test home directory configs
stow -nv zsh tmux

# Test .config directory configs
stow -nv -t ~/.config nvim hypr waybar wofi kitty
stow -nv -t ~/.config/Code/User Code
```

### Install Configurations

If the dry run looks good, install the configurations:

```bash
# Install home directory configs
stow -v zsh tmux

# Install .config directory configs  
stow -v -t ~/.config nvim hypr waybar wofi kitty
stow -v -t ~/.config/Code/User Code
```

### Individual Configuration Commands

Install configurations one by one:

```bash
# Core shell and editor
stow -v zsh         # ~/.zshrc, ~/.zsh/
stow -v tmux        # ~/.tmux.conf

# Wayland desktop environment and editors
stow -v -t ~/.config nvim     # ~/.config/nvim/
stow -v -t ~/.config hypr     # ~/.config/hypr/
stow -v -t ~/.config waybar   # ~/.config/waybar/
stow -v -t ~/.config wofi     # ~/.config/wofi/
stow -v -t ~/.config kitty    # ~/.config/kitty/

# Web browser
stow -v -t ~/.config/qutebrowser qutebrowser

# Development tools
stow -v -t ~/.config/Code Code  # ~/.config/Code/User/
```

### Uninstalling Configurations

To remove symlinks (this won't delete your data):

```bash
# Remove individual configs
stow -D zsh tmux
stow -D -t ~/.config nvim hypr waybar wofi kitty
stow -D -t ~/.config/Code/User Code

# Or remove all at once
stow -D */
```
