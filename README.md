# Zoom Reset & Reinstall Tool

> ⚠️ **PRERELEASE** — This tool is in early testing. We need feedback from **macOS** and **Windows** users! Please contact the Telegram group **[NUKE 1132](https://t.me/nuke1132)** with any issues, screenshots, or device info.

A cross-platform tool that fixes **Zoom Error 1132** and other connection issues by completely resetting and reinstalling Zoom.

Works on **Windows**, **macOS**, and **Linux**.

---

## The Problem

**Error 1132** is a widespread Zoom bug that prevents you from joining meetings. You might see:

- "Your connection is unstable"
- "Error code: 1132"
- Meetings won't connect even though your internet is fine

**This is NOT a network problem.** It's a Zoom bug that corrupts your local user profile data. A normal reinstall doesn't fix it because the corrupted data stays behind.

## The Solution

This tool performs a **complete** reset:

1. Kills any running Zoom processes
2. Uninstalls Zoom completely
3. Deletes ALL Zoom data (cache, settings, profiles)
4. Downloads the latest Zoom installer
5. Installs fresh
6. Launches Zoom

---

## Quick Start

### Windows

1. Download this repository and extract it
2. Double-click **`zoom-reset.bat`**
3. Follow the prompts (click "Yes" if asked for admin permission)

### macOS

1. Download this repository and extract it
2. Open Terminal in the extracted folder
3. Run:
   ```bash
   ./zoom-reset.sh
   ```
4. Enter your password when prompted

### Linux

1. Download this repository and extract it
2. Open Terminal in the extracted folder
3. Run:
   ```bash
   ./zoom-reset.sh
   ```
4. Enter your password when prompted

---

## Still Getting Error 1132?

If the standard reset doesn't work, the corruption may be deeper in your user profile. Try **Separate User Mode**, which creates a fresh Windows/macOS/Linux user account with a completely clean Zoom installation.

### Windows
```cmd
zoom-reset.bat -SeparateUser
```

### macOS / Linux
```bash
./zoom-reset.sh -SeparateUser
```

You'll be prompted to:
1. Enter a username for the new account
2. Set a password
3. Optionally grant admin/sudo privileges

Then switch to that user account and run Zoom from there.

---

## What This Tool Does

1. ✓ Stops Zoom if it's running
2. ✓ Removes all Zoom application files
3. ✓ Removes all Zoom user data and settings
4. ✓ Downloads the latest Zoom installer
5. ✓ Installs Zoom fresh
6. ✓ Launches Zoom

---

## Requirements

- **Internet connection** — to download the latest Zoom installer
- **Admin/sudo access** — to uninstall and install applications

> **Note:** The wrapper scripts (`zoom-reset.bat` and `zoom-reset.sh`) will offer to install PowerShell Core if it's not already installed.

---

## How It Works

| Step | Windows | macOS | Linux |
|------|---------|-------|-------|
| Kill Zoom | `Stop-Process -Name Zoom*` | `pkill -x "zoom.us"` | `pkill zoom` |
| Uninstall | WMI + folder removal | Delete `.app` bundle | `apt remove --purge` |
| Clean data | `AppData\Roaming\Zoom`, `AppData\Local\Zoom` | `~/Library/Application Support/zoom.us` | `~/.zoom`, `~/.config/zoom` |
| Download | `ZoomInstallerFull.exe` | `Zoom.pkg` | `zoom_amd64.deb` |
| Install | Silent installer | `installer -pkg` | `apt install` |

---

## FAQ

**Will this delete my Zoom account?**

No. This only affects the Zoom app on your computer. Your Zoom account, meetings, recordings, and contacts are stored on Zoom's servers and remain safe.

**Will I need to sign in again?**

Yes. After the reset, Zoom will be like a brand new installation. You'll need to sign in with your Zoom account.

**Is this safe to run?**

Yes. The script only touches Zoom-related files. It's open source — you can review every line of code before running it.

**What if -SeparateUser doesn't work?**

Contact Zoom Support: https://support.zoom.us/ — Error 1132 is a known bug on their end.

**Do I need to install anything first?**

The wrapper scripts will install PowerShell Core automatically if needed. Just run `zoom-reset.bat` (Windows) or `zoom-reset.sh` (macOS/Linux).

---

## Project Structure

```
zoom-error-1132-fix/
├── zoom-reset.bat              # Windows launcher
├── zoom-reset.sh               # macOS/Linux launcher
├── zoom-reset-and-reinstall.ps1  # Main cross-platform script
└── README.md
```

---

## License

MIT License — free to use, modify, and distribute.

---

## Help Us Test! 🧪

This is a **prerelease**. The script has been developed but needs real-world testing on different systems.

**We especially need feedback from:**
- ✅ Linux — Initial testing complete
- 🧪 **macOS** — Needs testing!
- 🧪 **Windows** — Needs testing!

If you try this tool, please contact **[NUKE 1132](https://t.me/nuke1132)** on Telegram and include:
- Your operating system and version
- Whether you used `-SeparateUser` mode
- Whether the reset worked or not
- Any error messages or screenshots

Please do **not** open GitHub issues — direct your feedback to **[NUKE 1132](https://t.me/nuke1132)** on Telegram.

---

If you're comfortable with GitHub issues and still want to post there, note that we prefer Telegram feedback during this prerelease phase.
