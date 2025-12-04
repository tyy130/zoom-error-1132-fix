# Zoom Reset & Reinstall Tool

**Fixes Zoom Error 1132** and other connection issues with a complete reset and fresh install.

## What is Error 1132?

Error 1132 is a widespread Zoom bug that displays "Your connection is unstable" or prevents you from joining meetings. **This is not a network problem** — it's a Zoom bug that corrupts your user profile data. A normal reinstall often doesn't fix it because the corrupted data remains.

This tool completely removes Zoom and all its data, then installs a fresh copy.

## Quick Start

### Windows
1. Download this folder
2. Double-click **`zoom-reset.bat`**
3. Follow the prompts

### Mac
1. Download this folder
2. Open Terminal in this folder
3. Run: `./zoom-reset.sh`
4. Follow the prompts

### Linux
1. Download this folder
2. Open Terminal in this folder
3. Run: `./zoom-reset.sh`
4. Follow the prompts

## Still Getting Error 1132?

If a normal reset doesn't fix it, try **Separate User Mode**. This creates a fresh user account on your computer with a completely clean Zoom profile.

### Windows
```
zoom-reset.bat -SeparateUser
```

### Mac / Linux
```
./zoom-reset.sh -SeparateUser
```

You'll be prompted to:
1. Enter a username for the new account
2. Set a password
3. (Optional) Give the account admin privileges

Then log into that account and use Zoom from there.

## What This Tool Does

1. ✓ Stops Zoom if it's running
2. ✓ Removes all Zoom application files
3. ✓ Removes all Zoom user data and settings
4. ✓ Downloads the latest Zoom installer
5. ✓ Installs Zoom fresh
6. ✓ Launches Zoom

## Requirements

- Internet connection (to download Zoom)
- Administrator/sudo access (to uninstall and install)

The script will automatically install PowerShell if needed — just follow the prompts.

## FAQ

**Q: Will this delete my Zoom account?**  
A: No. This only resets the Zoom app on your computer. Your Zoom account, meetings, and cloud recordings are safe.

**Q: Will I need to sign in again?**  
A: Yes. After the reset, Zoom will be like a fresh install and you'll need to sign in.

**Q: What if -SeparateUser doesn't work?**  
A: Contact Zoom support. This is a known bug they're working on fixing.

**Q: Is this safe?**  
A: Yes. The script only touches Zoom files and (optionally) creates a new user account. You can review the code — it's open source.

## License

MIT — Use freely, no warranty.
