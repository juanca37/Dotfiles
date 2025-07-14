#!/usr/bin/env bash

# Dotfiles Install Script
# Supports macOS, Linux, and Windows (WSL)

set +e  # Disable exit on error - we handle errors manually

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ -n "$WSL_DISTRO_NAME" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Function to show OS selection menu
select_os() {
    local detected_os=$(detect_os)
    
    print_info "Dotfiles Installation Script"
    echo ""
    
    # If OS detected, ask for confirmation
    if [[ "$detected_os" != "unknown" ]]; then
        local os_name=""
        case "$detected_os" in
            "linux") os_name="Linux" ;;
            "macos") os_name="macOS" ;;
            "windows") os_name="Windows (WSL)" ;;
        esac
        
        print_info "Auto-detected: $os_name"
        read -p "Is this correct? (y/n): " confirm
        
        if [[ "$confirm" =~ ^[Yy]([Ee][Ss])?$ ]]; then
            case "$detected_os" in
                "linux") return 1 ;;
                "macos") return 2 ;;
                "windows") return 3 ;;
            esac
        fi
        
        echo ""
        print_info "Please select manually:"
    else
        print_warning "Could not auto-detect OS. Please select manually:"
    fi
    
    echo ""
    echo "Please select your operating system:"
    echo "1) Linux"
    echo "2) macOS" 
    echo "3) Windows (WSL)"
    echo "4) Exit"
    echo ""
    
    # Manual selection
    read -p "Enter your choice (1-4): " choice
    
    case $choice in
        1) return 1 ;;
        2) return 2 ;;
        3) return 3 ;;
        4) 
            print_info "Installation cancelled."
            exit 0
            ;;
        *)
            print_error "Invalid choice. Please try again."
            echo ""
            select_os
            ;;
    esac
}

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to check dependencies for each configuration
check_dependencies() {
    local config="$1"
    local missing_deps=()
    
    case "$config" in
        "Code")
            if ! command_exists "code"; then
                missing_deps+=("vscode")
            fi
            ;;
        "hypr")
            if ! command_exists "hyprland"; then
                missing_deps+=("hyprland")
            fi
            if ! command_exists "waybar"; then
                missing_deps+=("waybar")
            fi
            if ! command_exists "hyprpaper"; then
                missing_deps+=("hyprpaper")
            fi
            if ! command_exists "hyprlock"; then
                missing_deps+=("hyprlock")
            fi
            if ! command_exists "hyprshot"; then
                missing_deps+=("hyprshot")
            fi
            if ! command_exists "bluetoothctl"; then
                missing_deps+=("bluez-utils")
            fi
            if ! command_exists "wpctl"; then
                missing_deps+=("wireplumber")
            fi
            if ! command_exists "wofi"; then
                missing_deps+=("wofi")
            fi
            if ! command_exists "kitty"; then
                missing_deps+=("kitty")
            fi
            ;;
        "kitty")
            if ! command_exists "kitty"; then
                missing_deps+=("kitty")
            fi
            ;;
        "nvim")
            if ! command_exists "nvim"; then
                missing_deps+=("neovim")
            fi
            ;;
        "tmux")
            if ! command_exists "tmux"; then
                missing_deps+=("tmux")
            fi
            ;;
        "waybar")
            if ! command_exists "waybar"; then
                missing_deps+=("waybar")
            fi
            ;;
        "wofi")
            if ! command_exists "wofi"; then
                missing_deps+=("wofi")
            fi
            ;;
        "zsh")
            if ! command_exists "zsh"; then
                missing_deps+=("zsh")
            fi
            ;;
    esac
    
    echo "${missing_deps[@]}"
}

# Function to show dependency status
show_config_status() {
    local config="$1"
    local missing_deps=($(check_dependencies "$config"))
    
    if [[ ${#missing_deps[@]} -eq 0 ]]; then
        echo -e "  $2) ${GREEN}✓${NC} $config"
        return 0
    else
        echo -e "  $2) ${RED}✗${NC} $config ${YELLOW}(missing: ${missing_deps[*]})${NC}"
        return 1
    fi
}

# Function to install for Linux
install_linux() {
    print_info "Installing dotfiles for Linux..."
    echo ""
    
    # Get available configurations by listing directories
    local available_configs=()
    for dir in "$DOTFILES_DIR"/*/; do
        if [[ -d "$dir" ]]; then
            local config_name=$(basename "$dir")
            # Skip hidden directories and this script's directory
            if [[ ! "$config_name" =~ ^\. ]] && [[ "$config_name" != "." ]] && [[ "$config_name" != ".." ]]; then
                available_configs+=("$config_name")
            fi
        fi
    done
    
    if [[ ${#available_configs[@]} -eq 0 ]]; then
        print_error "No configuration directories found!"
        return 1
    fi
    
    # Check dependencies and show status
    print_info "Available configurations (${GREEN}✓${NC} = ready, ${RED}✗${NC} = missing dependencies):"
    echo ""
    
    local installable_configs=()
    local config_numbers=()
    
    for i in "${!available_configs[@]}"; do
        local config="${available_configs[i]}"
        if show_config_status "$config" "$((i+1))"; then
            installable_configs+=("$config")
            config_numbers+=("$((i+1))")
        fi
    done
    
    echo ""
    
    if [[ ${#installable_configs[@]} -eq 0 ]]; then
        print_warning "No configurations have all dependencies installed."
        print_info "Please install the missing packages and run the script again."
        return 1
    fi
    
    print_info "You can install configurations that have all dependencies (${GREEN}✓${NC})."
    print_warning "Configurations with missing dependencies (${RED}✗${NC}) will be skipped."
    echo ""
    
    # Simple interactive menu
    local selected_configs=()
    
    print_info "Enter numbers for configurations you want to install (space-separated):"
    echo ""
    
    read -p "Select configurations to install (numbers): " selection
    
    # Parse selection
    for num in $selection; do
        if [[ "$num" =~ ^[0-9]+$ ]] && [[ "$num" -ge 1 ]] && [[ "$num" -le "${#available_configs[@]}" ]]; then
            local config_name="${available_configs[$((num-1))]}"
            
            # Check if this config has all dependencies
            local missing_deps=($(check_dependencies "$config_name"))
            if [[ ${#missing_deps[@]} -gt 0 ]]; then
                print_warning "Skipping $config_name - missing dependencies: ${missing_deps[*]}"
                continue
            fi
            
            # Check if already added
            local already_added=false
            for selected in "${selected_configs[@]}"; do
                if [[ "$selected" == "$config_name" ]]; then
                    already_added=true
                    break
                fi
            done
            if [[ "$already_added" == false ]]; then
                selected_configs+=("$config_name")
            fi
        fi
    done
    
    # Show results
    echo ""
    if [[ ${#selected_configs[@]} -eq 0 ]]; then
        print_warning "No valid configurations selected."
    else
        print_success "You selected: ${selected_configs[*]}"
        print_info "All selected configurations have their dependencies installed!"
        print_info "Ready to install these configurations!"
    fi
}

# Function to install for macOS
install_macos() {
    print_info "Installing dotfiles for macOS..."
    
    # TODO: Add macOS-specific installation steps
    # - Check for Homebrew
    # - Install required packages
    # - Stow configurations
    
    print_warning "macOS installation not yet implemented"
}

# Function to install for Windows/WSL
install_windows() {
    print_info "Installing dotfiles for Windows (WSL)..."
    
    # TODO: Add Windows/WSL-specific installation steps
    # - Check WSL version
    # - Install required packages
    # - Handle Windows-specific paths
    
    print_warning "Windows installation not yet implemented"
}

# Main installation function
main() {
    # Get script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    DOTFILES_DIR="$SCRIPT_DIR"
    
    print_info "Dotfiles directory: $DOTFILES_DIR"
    echo ""
    
    # Select OS
    select_os
    local os_choice=$?
    
    echo ""
    
    # Install based on selection
    case $os_choice in
        1)
            install_linux
            ;;
        2)
            install_macos
            ;;
        3)
            install_windows
            ;;
    esac
    
    print_success "Installation process completed!"
}

# Run main function
main "$@"
