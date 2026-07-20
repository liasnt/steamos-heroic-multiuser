# SteamOS Heroic Games Launcher - Dynamic Multi-User & Prefix Isolator

An automated utility for **SteamOS (Steam Machine / Steam Deck)** that dynamically isolates login sessions, launcher configurations, Epic/GOG tokens, and Wine/Proton prefixes (including global save games) in **Heroic Games Launcher** based on the currently logged-in Steam user.

---

## 🤔 Why This Exists?

SteamOS turns devices like the **Steam Deck** or a living room **Steam Machine** into shared family consoles. While Steam native games handle account switching seamlessly, third-party launchers like **Heroic Games Launcher** treat the entire system as a single user.

In a household with multiple family members sharing the same device:
- **Overwritten Saves:** Player A's save games in Epic/GOG titles can easily overwrite Player B's progress.
- **Shared Logins:** Switching Steam profiles doesn't switch Epic Games or GOG accounts in Heroic Games Launcher.

This script fixes that completely! It automatically detects which Steam user is active and redirects Heroic's settings, logins, and Wine save locations to an isolated directory for that specific family member.

---

## 🌟 Features

- **Dynamic Steam User Detection**: Reads the active Steam profile from `loginusers.vdf` (with automated VDF registry fallback).
- **Complete Profile Isolation**: Separates Heroic Games Launcher settings, Epic Games (`legendary`), and GOG configurations per Steam user.
- **Save Game & Prefix Separation**: Redirects default Wine prefixes to user-specific directories (`~/.var/app/com.heroicgameslauncher.hgl/steam-profile-<ID>/prefixes`), preventing save game overwrite across multiple Steam accounts.
- **Fail-Safe Launcher**: Heroic Games Launcher only executes if all symlinks and directory structures are verified without error.

---

## 🖥️ How to Access Desktop Mode

Before installing, you need to switch to Desktop Mode on your device:
1. Press the **STEAM** button on your Steam Machine / Steam Deck (or open the Power menu on SteamOS).
2. Select **Power** > **Switch to Desktop**.
3. Wait a few seconds for the Desktop environment to load.

---

## 📋 Prerequisites & Compatibility

- **SteamOS**: Tested and verified on **SteamOS v3.8.16** (Steam Machine).
- **Heroic Games Launcher**: Must be installed via the **Discover Store** in Desktop Mode.
---

## 🚀 One-Line Installation

Open the **Konsole** app on your Steam Machine / Steam Deck (Desktop Mode) and paste the following command:

```bash
curl -sSL https://raw.githubusercontent.com/liasnt/steamos-heroic-multiuser/refs/heads/main/install_Heroic-Multiuser.sh | bash
```

---

## ⚙️ How to Setup on Steam / Game Mode

1. Switch to **Desktop Mode** on your Steam Machine / Steam Deck.
2. Open **Steam**.
3. Add the script to Steam using either method:
   - **Option A (Recommended):** In the bottom-left corner of Steam, click **+ Add a Game** > **Add a Non-Steam Game...**
   - **Option B (Top Menu):** Click **Games** in the top menu bar > **Add a Non-Steam Game to My Library...**
4. Click **Browse** and navigate to:
   `/home/deck/.local/bin/heroic-multiuser.sh`
   *(Tip: Press `Ctrl + H` in the file picker to show hidden folders).*
5. Select `heroic-multiuser.sh` and click **Add Selected Programs**.
6. Right-click the newly added shortcut in Steam, select **Properties**, and set:
   - **Target**: `"/home/deck/.local/bin/heroic-multiuser.sh"`
   - **Name**: `Heroic Games Launcher`
7. Switch back to **Gaming Mode** and launch Heroic!

---

## 🛠️ How It Works

1. On launch, the script queries Steam's configuration files to identify the active user's short Steam ID.
2. Creates isolated directories under:
   `~/.var/app/com.heroicgameslauncher.hgl/steam-profile-<STEAM_ID>/`
3. Dynamically updates symlinks for `heroic`, `legendary`, and global Wine `prefixes` before starting the Flatpak container.
4. Ensures user A's save files, game logins, and achievements never interfere with user B's.

---

## 🤝 Contributing & Issues

Found a bug or have a feature request? Feel free to open an issue or submit a Pull Request on this repository.

---

## 📜 License

Distributed under the MIT License. See `LICENSE` for more details.
