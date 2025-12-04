# Copilot Instructions for Zoom Reset & Reinstall Script

## Project Overview

Single-file cross-platform PowerShell (pwsh) script that performs a complete Zoom reset and reinstall. Targets Linux, macOS, and Windows from one script using PowerShell's automatic `$IsLinux`, `$IsMacOS`, and `$IsWindows` variables.

## Architecture

**Single entry point:** `zoom-reset-and-reinstall.ps1`

Each OS branch follows the same workflow:
1. Kill running Zoom process
2. Remove application files and user data
3. Download latest installer from `zoom.us`
4. Install fresh
5. Launch Zoom

## Key Conventions

### PowerShell Cross-Platform Patterns

- Use `pwsh` (PowerShell Core), not Windows PowerShell
- Use automatic variables for OS detection: `$IsLinux`, `$IsMacOS`, `$IsWindows`
- Wrap native commands that may fail in `try/catch {}` with error suppression
- Use `sudo` for privileged operations on Linux/macOS

### Output Style

```powershell
Write-Host "Status message..." -ForegroundColor Cyan    # Progress/info
Write-Host "OS-specific step..." -ForegroundColor Green  # OS detection
Write-Host "Warning/removal..." -ForegroundColor Yellow  # Destructive actions
Write-Host "Error message..." -ForegroundColor Red       # Failures
```

### Error Handling

- Suppress expected errors (e.g., killing processes that aren't running)
- Use `-ErrorAction SilentlyContinue` for optional cleanup paths
- Let critical failures (downloads, installs) propagate naturally

## Running the Script

### Using Wrapper Scripts (Recommended)

The wrapper scripts automatically check for PowerShell Core and offer to install it if missing:

```bash
# Linux/macOS
./zoom-reset.sh
./zoom-reset.sh -SeparateUser

# Windows (Command Prompt or PowerShell)
zoom-reset.bat
zoom-reset.bat -SeparateUser
```

### Direct PowerShell Execution

If you already have `pwsh` installed:

```bash
# Standard reset + reinstall (current user)
pwsh ./zoom-reset-and-reinstall.ps1

# Reset + reinstall, launch as separate user
pwsh ./zoom-reset-and-reinstall.ps1 -SeparateUser
```

**Requirements:**
- PowerShell Core (`pwsh`) - wrapper scripts will help install if missing
- Admin/sudo access for uninstall and install operations
- Internet access to download from `zoom.us`

## Separate User Mode (Error 1132 Workaround)

Zoom Error 1132 is a widespread bug where Zoom fails to connect to meetings, displaying "Your connection is unstable" or error code 1132. This is a **known Zoom bug** (not a network issue) that often persists despite reinstalls because it corrupts user profile data.

The `-SeparateUser` flag creates a fresh user account with a clean Zoom profile, bypassing the corrupted state:

| OS | User Creation | Launch Method |
|----|---------------|---------------|
| **Linux** | `useradd` + `passwd` | Manual login required |
| **macOS** | `sysadminctl -addUser` | Manual login or Fast User Switching |
| **Windows** | `New-LocalUser` | Auto-launches via `runas.exe` |

Features:
- Prompts for username (creates if doesn't exist)
- Secure password input with confirmation
- Optional admin/sudo privileges

## Extending the Script

When adding features:
- Maintain the single-file design for portability
- Keep OS branches self-contained within their `if/elseif` block
- Follow existing color conventions for user feedback
- Download to user's Downloads folder consistently across platforms
