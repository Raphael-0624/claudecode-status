#!/bin/bash
#
# Claude Code Status Bar Installer
# https://github.com/rockelbel/claudecode-status
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SCRIPTS_DIR="$CLAUDE_DIR/scripts"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

# Colors
C_RESET='\033[0m'
C_GREEN='\033[32m'
C_BLUE='\033[34m'
C_YELLOW='\033[33m'
C_RED='\033[31m'
C_GRAY='\033[90m'

print_banner() {
    echo ""
    echo -e "${C_BLUE}╔══════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_BLUE}║${C_RESET}           ${C_GREEN}Claude Code Status Bar Installer${C_RESET}              ${C_BLUE}║${C_RESET}"
    echo -e "${C_BLUE}║${C_RESET}                    ${C_GRAY}v1.0.0${C_RESET}                              ${C_BLUE}║${C_RESET}"
    echo -e "${C_BLUE}╚══════════════════════════════════════════════════════════╝${C_RESET}"
    echo ""
}

print_success() {
    echo -e "${C_GREEN}✓${C_RESET} $1"
}

print_info() {
    echo -e "${C_BLUE}ℹ${C_RESET} $1"
}

print_warning() {
    echo -e "${C_YELLOW}⚠${C_RESET} $1"
}

print_error() {
    echo -e "${C_RED}✗${C_RESET} $1"
}

ask_yes_no() {
    local prompt="$1"
    local default="${2:-y}"
    local answer

    if [[ "$default" == "y" ]]; then
        read -p "$prompt [Y/n]: " answer
    else
        read -p "$prompt [y/N]: " answer
    fi

    answer=${answer:-$default}
    [[ "$answer" =~ ^[Yy]$ ]]
}

ask_choice() {
    local prompt="$1"
    shift
    local options=("$@")
    local choice

    echo -e "${C_BLUE}$prompt${C_RESET}"
    for i in "${!options[@]}"; do
        echo "  $((i+1)). ${options[$i]}"
    done

    while true; do
        read -p "Enter choice (1-${#options[@]}): " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#options[@]} )); then
            echo "$((choice-1))"
            return
        fi
        print_error "Invalid choice, please try again"
    done
}

# ==================== INSTALLATION ====================

print_banner

# Check prerequisites
print_info "Checking prerequisites..."

if ! command -v jq &> /dev/null; then
    print_error "jq is required but not installed"
    echo "  Install with: sudo apt-get install jq  (Debian/Ubuntu)"
    echo "           or:  brew install jq          (macOS)"
    exit 1
fi

if ! command -v git &> /dev/null; then
    print_error "git is required but not installed"
    exit 1
fi

print_success "Prerequisites check passed"

# Create directories
print_info "Creating directories..."
mkdir -p "$SCRIPTS_DIR"
print_success "Created $SCRIPTS_DIR"

# ==================== CONFIGURATION ====================

echo ""
echo -e "${C_BLUE}═══════════════════════════════════════════════════════════${C_RESET}"
echo -e "${C_BLUE}              Configuration${C_RESET}"
echo -e "${C_BLUE}═══════════════════════════════════════════════════════════${C_RESET}"
echo ""

# Theme selection
echo ""
echo -e "${C_BLUE}Step 1: Choose Color Theme${C_RESET}"
themes=("gray" "orange" "blue" "teal" "green" "lavender" "rose" "gold" "slate" "cyan")
theme_idx=$(ask_choice "Select your preferred color theme:" "${themes[@]}")
SELECTED_THEME="${themes[$theme_idx]}"
print_success "Selected theme: $SELECTED_THEME"

# Module selection
echo ""
echo -e "${C_BLUE}Step 2: Select Status Bar Modules${C_RESET}"
echo -e "${C_GRAY}The following modules are available. Toggle each on/off.${C_RESET}"
echo ""

# Default enabled modules
SHOW_GIT="false"
SHOW_PROJECT_TYPE="true"
SHOW_CLAUDE_MD="true"
SHOW_TIME="false"
SHOW_SYSTEM="false"
SHOW_CLOUD="false"

echo -e "${C_GREEN}Default enabled (recommended):${C_RESET}"
echo "  ✓ Project Type Detection - Shows 📦 Node / 🐍 Python / 🦀 Rust etc."
echo "  ✓ CLAUDE.md Indicator - Shows 📋 when CLAUDE.md exists"
echo ""

if ask_yes_no "Enable Git information? (branch, file status, sync status)" "n"; then
    SHOW_GIT="true"
    print_success "Git info enabled"
else
    print_info "Git info disabled"
fi

if ask_yes_no "Enable Time display? (current time 🕐)" "n"; then
    SHOW_TIME="true"
    print_success "Time display enabled"
else
    print_info "Time display disabled"
fi

if ask_yes_no "Enable System Resources? (memory usage 💾)" "n"; then
    SHOW_SYSTEM="true"
    print_success "System resources enabled"
else
    print_info "System resources disabled"
fi

if ask_yes_no "Enable Cloud Environment detection? (☁️ Alibaba Cloud etc.)" "n"; then
    SHOW_CLOUD="true"
    print_success "Cloud detection enabled"
else
    print_info "Cloud detection disabled"
fi

# ==================== GENERATE SCRIPT ====================

echo ""
echo -e "${C_BLUE}═══════════════════════════════════════════════════════════${C_RESET}"
echo -e "${C_BLUE}              Generating Status Bar Script${C_RESET}"
echo -e "${C_BLUE}═══════════════════════════════════════════════════════════${C_RESET}"
echo ""

# Determine template source
if [[ -f "$SCRIPT_DIR/src/templates/status-bar.template.sh" ]]; then
    TEMPLATE="$SCRIPT_DIR/src/templates/status-bar.template.sh"
elif [[ -f "./src/templates/status-bar.template.sh" ]]; then
    TEMPLATE="./src/templates/status-bar.template.sh"
else
    # Download from GitHub
    print_info "Downloading template from GitHub..."
    TEMPLATE="/tmp/status-bar.template.sh"
    curl -fsSL "https://raw.githubusercontent.com/rockelbel/claudecode-status/main/src/templates/status-bar.template.sh" -o "$TEMPLATE" 2>/dev/null || {
        print_error "Failed to download template"
        exit 1
    }
fi

# Generate the script
OUTPUT_SCRIPT="$SCRIPTS_DIR/status-bar.sh"

print_info "Generating customized status bar script..."

# Replace placeholders in template
sed -e "s/\[\[COLOR\]\]/$SELECTED_THEME/g" \
    -e "s/\[\[SHOW_GIT\]\]/$SHOW_GIT/g" \
    -e "s/\[\[SHOW_PROJECT_TYPE\]\]/$SHOW_PROJECT_TYPE/g" \
    -e "s/\[\[SHOW_CLAUDE_MD\]\]/$SHOW_CLAUDE_MD/g" \
    -e "s/\[\[SHOW_TIME\]\]/$SHOW_TIME/g" \
    -e "s/\[\[SHOW_SYSTEM\]\]/$SHOW_SYSTEM/g" \
    -e "s/\[\[SHOW_CLOUD\]\]/$SHOW_CLOUD/g" \
    -e "s/\[\[GITHUB_USER\]\]/rockelbel/g" \
    "$TEMPLATE" > "$OUTPUT_SCRIPT"

chmod +x "$OUTPUT_SCRIPT"
print_success "Generated $OUTPUT_SCRIPT"

# ==================== CONFIGURE CLAUDE CODE ====================

echo ""
echo -e "${C_BLUE}═══════════════════════════════════════════════════════════${C_RESET}"
echo -e "${C_BLUE}              Configuring Claude Code${C_RESET}"
echo -e "${C_BLUE}═══════════════════════════════════════════════════════════${C_RESET}"
echo ""

# Check if settings.json exists
if [[ -f "$SETTINGS_FILE" ]]; then
    print_info "Found existing settings.json"

    # Backup existing settings
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    print_success "Created backup of existing settings"

    # Check if statusLine already configured
    if jq -e '.statusLine' "$SETTINGS_FILE" > /dev/null 2>&1; then
        print_warning "Status line already configured"
        if ! ask_yes_no "Overwrite existing status line configuration?" "y"; then
            print_info "Keeping existing configuration"
            echo ""
            echo -e "${C_YELLOW}To manually configure, add this to ~/.claude/settings.json:${C_RESET}"
            echo '  "statusLine": {'
            echo '    "type": "command",'
            echo '    "command": "~/.claude/scripts/status-bar.sh"'
            echo '  }'
            exit 0
        fi
    fi

    # Update existing settings
    jq '. + {"statusLine": {"type": "command", "command": "~/.claude/scripts/status-bar.sh"}}' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
else
    print_info "Creating new settings.json"
    mkdir -p "$CLAUDE_DIR"
    cat > "$SETTINGS_FILE" << 'EOF'
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/scripts/status-bar.sh"
  }
}
EOF
fi

print_success "Updated settings.json"

# ==================== SUMMARY ====================

echo ""
echo -e "${C_GREEN}═══════════════════════════════════════════════════════════${C_RESET}"
echo -e "${C_GREEN}              Installation Complete!${C_RESET}"
echo -e "${C_GREEN}═══════════════════════════════════════════════════════════${C_RESET}"
echo ""
echo -e "${C_BLUE}Configuration Summary:${C_RESET}"
echo "  Theme: $SELECTED_THEME"
echo "  Modules enabled:"
echo "    ✓ Model name & token usage (always)"
[[ "$SHOW_PROJECT_TYPE" == "true" ]] && echo "    ✓ Project type detection"
[[ "$SHOW_CLAUDE_MD" == "true" ]] && echo "    ✓ CLAUDE.md indicator"
[[ "$SHOW_GIT" == "true" ]] && echo "    ✓ Git information"
[[ "$SHOW_TIME" == "true" ]] && echo "    ✓ Time display"
[[ "$SHOW_SYSTEM" == "true" ]] && echo "    ✓ System resources"
[[ "$SHOW_CLOUD" == "true" ]] && echo "    ✓ Cloud environment"
echo ""
echo -e "${C_BLUE}Files created:${C_RESET}"
echo "  Script: $OUTPUT_SCRIPT"
echo "  Config: $SETTINGS_FILE"
echo ""
echo -e "${C_YELLOW}Next steps:${C_RESET}"
echo "  1. Restart Claude Code or open a new session"
echo "  2. The status bar will appear at the bottom of your terminal"
echo ""
echo -e "${C_GRAY}To reconfigure, run this installer again.${C_RESET}"
echo -e "${C_GRAY}To uninstall, remove the statusLine config from ~/.claude/settings.json${C_RESET}"
echo ""
