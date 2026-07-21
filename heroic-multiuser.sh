#!/bin/bash
# ==============================================================================
# Title:        SteamOS Heroic Launcher - Dynamic Multi-User & Prefix Isolator
# Description:  Isolates Heroic logins, configs, and Wine prefixes (including
#               global game saves) dynamically based on the active Steam user.
# Author:       The SteamOS Tinkerer (Reddit: u/CiberOne)
# Version:      1.0
# Date:         2026-07-16
# ==============================================================================

# 1. Base paths on SteamOS
STEAM_USERDATA="$HOME/.steam/steam/userdata"
HEROIC_VAR_DIR="$HOME/.var/app/com.heroicgameslauncher.hgl"
HEROIC_CONFIG_DIR="$HEROIC_VAR_DIR/config"

# Ensure the original directory tree exists physically
[ -L "$HEROIC_CONFIG_DIR" ] && rm -f "$HEROIC_CONFIG_DIR"
mkdir -p "$HEROIC_CONFIG_DIR" || { echo "ERROR: Could not create Heroic config folder!"; exit 1; }

# 2. Detect active Steam User ID via Python
STEAM_ID=$(python3 -c '
import re, os
p = os.path.expanduser("~/.steam/steam/config/loginusers.vdf")
if os.path.exists(p):
    c = open(p).read()
    u = re.findall(r"\"(\d+)\"\s*\{([^}]+)\}", c)
    times = [(int(re.search(r"\"Timestamp\"\s*\"(\d+)\"", b).group(1)), uid) for uid, b in u if re.search(r"\"Timestamp\"\s*\"(\d+)\"", b)]
    if times: print(int(max(times)[1]) - 76561197960265728)
' 2>/dev/null)

# Plan B: If Python fails, fallback to ActiveUser in registry.vdf
if [ -z "$STEAM_ID" ] || [ "$STEAM_ID" = "0" ]; then
    STEAM_ID=$(grep -A 4 -i "ActiveUser" "$HOME/.steam/steam/config/registry.vdf" 2>/dev/null | grep -oE '[0-9]+' | head -n 1)
fi

# Plan C: Absolute safety fallback
if [ -z "$STEAM_ID" ] || [ "$STEAM_ID" = "0" ]; then
    STEAM_ID="default_user"
fi

echo "Active Steam user detected (Short ID): $STEAM_ID"

# 3. Define and create unified directory for this specific user
USER_MAIN_DIR="$HEROIC_VAR_DIR/steam-profile-$STEAM_ID"

mkdir -p "$USER_MAIN_DIR/heroic" || { echo "ERROR: Could not create heroic folder for profile!"; exit 1; }
mkdir -p "$USER_MAIN_DIR/legendary" || { echo "ERROR: Could not create legendary folder for profile!"; exit 1; }

# 4. Resolve symlinks for subdirectories (with error validation)
rm -rf "$HEROIC_CONFIG_DIR/heroic" || exit 1
rm -rf "$HEROIC_CONFIG_DIR/legendary" || exit 1

ln -s "$USER_MAIN_DIR/heroic" "$HEROIC_CONFIG_DIR/heroic" || { echo "ERROR: Failed to link heroic folder!"; exit 1; }
ln -s "$USER_MAIN_DIR/legendary" "$HEROIC_CONFIG_DIR/legendary" || { echo "ERROR: Failed to link legendary folder!"; exit 1; }

# 5. Isolate Heroic global Prefix folder for each user
GLOBAL_PREFIX_DIR="$HOME/Games/Heroic/Prefixes"
USER_PREFIX_DIR="$USER_MAIN_DIR/prefixes"

# Ensure user prefix directory exists
mkdir -p "$USER_PREFIX_DIR" || { echo "ERROR: Could not create user prefix folder!"; exit 1; }

# If global Heroic folder is a real directory, move content safely
if [ -d "$GLOBAL_PREFIX_DIR" ] && [ ! -L "$GLOBAL_PREFIX_DIR" ]; then
    if [ "$(ls -A "$GLOBAL_PREFIX_DIR" 2>/dev/null)" ]; then
        mv "$GLOBAL_PREFIX_DIR"/* "$USER_PREFIX_DIR/" 2>/dev/null
    fi
    rm -rf "$GLOBAL_PREFIX_DIR" || { echo "ERROR: Failed to clean global prefix folder!"; exit 1; }
fi

rm -f "$GLOBAL_PREFIX_DIR"
ln -s "$USER_PREFIX_DIR" "$GLOBAL_PREFIX_DIR" || { echo "ERROR: Failed to create global symlink!"; exit 1; }

echo "Symlinks successfully updated in unified user folder!"

# 6. Launch Heroic (Only runs if all preceding steps succeeded)
flatpak run --branch=stable --arch=x86_64 --command=heroic-run --file-forwarding com.heroicgameslauncher.hgl "$@" "@@u" "@@"
