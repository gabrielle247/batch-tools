#!/bin/bash

# ==========================================
#   CLUE AUTO-FIXER & SAFETY SYSTEM (v2.0)
# ==========================================

# CONFIGURATION
PROJECT_ROOT=$(pwd)
BACKUP_DIR="$PROJECT_ROOT/.clue_backups"
LIB_DIR="$PROJECT_ROOT/lib"

# COLORS
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_step() { echo -e "\n${CYAN}🔵 $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# --- 1. BACKUP SYSTEM ---
create_backup() {
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    TARGET="$BACKUP_DIR/backup_$TIMESTAMP"

    log_step "Creating backup at: $TARGET"

    if [ ! -d "$LIB_DIR" ]; then
        log_error "Library folder 'lib/' not found!"
        return 1
    fi

    mkdir -p "$TARGET"
    cp -r "$LIB_DIR" "$TARGET/"
    
    if [ $? -eq 0 ]; then
        log_success "Backup secure."
    else
        log_error "Backup failed."
        exit 1
    fi
}

restore_backup() {
    # Find latest backup (sorted by time, newest first)
    LATEST=$(ls -td "$BACKUP_DIR"/backup_* 2>/dev/null | head -1)

    if [ -z "$LATEST" ]; then
        log_error "No backups found to revert."
        return
    fi

    log_step "REVERTING changes from: $LATEST"

    # Nuke current lib
    rm -rf "$LIB_DIR"
    
    # Restore old lib
    cp -r "$LATEST/lib" "$PROJECT_ROOT/"

    if [ $? -eq 0 ]; then
        log_success "System restored to pre-fix state."
    else
        log_error "Restoration failed."
    fi
}

# --- 2. FIX LOGIC ---
apply_fixes() {
    log_step "Running 'dart fix --apply'..."
    
    dart fix --apply
    
    if [ $? -eq 0 ]; then
        log_success "Dart auto-fixes applied."
    else
        log_error "Dart fix encountered issues."
    fi
}

# --- 3. MAIN MENU ---
show_menu() {
    echo "========================================"
    echo "   CLUE AUTO-FIXER & SAFETY SYSTEM      "
    echo "========================================"
    echo "1. [APPLY] Backup & Fix All Code"
    echo "2. [REVERT] Restore Last Backup"
    echo "3. Exit"
    echo -n "Select Action (1-3): "
    read CHOICE

    case $CHOICE in
        1)
            create_backup
            apply_fixes
            ;;
        2)
            restore_backup
            ;;
        3)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}

# Run Menu
show_menu
