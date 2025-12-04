# Zoom reset + reinstall for Linux, macOS, and Windows
# Run with:  pwsh ./zoom-reset-and-reinstall.ps1
# Options:
#   -SeparateUser    Create/use a separate user account for Zoom
#
# Why this script exists:
#   Zoom Error 1132 is a widespread issue where Zoom fails to connect to meetings,
#   displaying "Your connection is unstable" or error code 1132. This is a known
#   Zoom bug (not a network issue) that often persists despite reinstalls.
#   Creating a separate user account provides a clean profile that bypasses the
#   corrupted state causing the error.

param(
    [switch]$SeparateUser
)

# Detect OS
$os = if ($IsLinux) { "Linux" } elseif ($IsMacOS) { "macOS" } elseif ($IsWindows) { "Windows" } else { $null }

if (-not $os) {
    Write-Host "Unsupported operating system." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "  Detected: $os" -ForegroundColor Cyan
Write-Host ""

if ($IsLinux) {
    Write-Host "Step 1/4: Stopping Zoom..." -ForegroundColor Cyan
    try { pkill zoom 2>/dev/null } catch {}
    Write-Host "  Done" -ForegroundColor Green

    Write-Host "Step 2/4: Removing old Zoom data..." -ForegroundColor Cyan
    sudo rm -rf ~/.zoom ~/.config/zoom ~/.cache/zoom
    sudo apt remove --purge zoom -y 2>/dev/null
    sudo apt autoremove --purge -y 2>/dev/null
    Write-Host "  Done" -ForegroundColor Green

    Write-Host "Step 3/4: Downloading fresh Zoom..." -ForegroundColor Cyan
    mkdir -p ~/Downloads | Out-Null
    wget -q https://zoom.us/client/latest/zoom_amd64.deb -O ~/Downloads/zoom.deb
    Write-Host "  Done" -ForegroundColor Green

    Write-Host "Step 4/4: Installing Zoom..." -ForegroundColor Cyan
    sudo apt install ~/Downloads/zoom.deb -y
    Write-Host "  Done" -ForegroundColor Green
    Write-Host ""

    # Handle separate user mode
    if ($SeparateUser) {
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
        Write-Host "  SEPARATE USER MODE (Error 1132 Fix)" -ForegroundColor Cyan
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "This creates a fresh user account with a clean Zoom profile." -ForegroundColor White
        Write-Host "Error 1132 corrupts your Zoom data - a new user bypasses this." -ForegroundColor White
        Write-Host ""
        
        $zoomUser = Read-Host "Enter a username for the new account"
        
        # Check if user exists
        $userCheck = sh -c "id '$zoomUser' 2>/dev/null"
        $userExists = $LASTEXITCODE -eq 0
        
        if (-not $userExists) {
            Write-Host "Creating new user '$zoomUser'..." -ForegroundColor Yellow
            
            # Create user with home directory
            sudo useradd -m -s /bin/bash $zoomUser
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Failed to create user." -ForegroundColor Red
                exit 1
            }
            
            # Set password
            Write-Host "Set password for '$zoomUser':" -ForegroundColor Cyan
            sudo passwd $zoomUser
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Failed to set password." -ForegroundColor Red
                exit 1
            }
            
            # Ask about sudo privileges
            $makeSudo = Read-Host "Add user to sudo group? (y/N)"
            if ($makeSudo -eq 'y' -or $makeSudo -eq 'Y') {
                sudo usermod -aG sudo $zoomUser
                Write-Host "User added to sudo group." -ForegroundColor Yellow
            }
            
            Write-Host "User '$zoomUser' created successfully." -ForegroundColor Green
        }
        else {
            Write-Host "User '$zoomUser' already exists. Ready to use!" -ForegroundColor Green
        }
        
        Write-Host ""
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host "  SUCCESS! Next steps:" -ForegroundColor Green
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host ""
        Write-Host "  1. Log out of your current session" -ForegroundColor White
        Write-Host "  2. Log in as '$zoomUser'" -ForegroundColor White
        Write-Host "  3. Open Zoom and join your meeting" -ForegroundColor White
        Write-Host ""
    }
    else {
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host "  SUCCESS! Zoom has been reset." -ForegroundColor Green
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host ""
        Write-Host "Launching Zoom..." -ForegroundColor Cyan
        zoom
    }

}
elseif ($IsMacOS) {
    Write-Host "Step 1/4: Stopping Zoom..." -ForegroundColor Cyan
    try { pkill -x "zoom.us" 2>/dev/null } catch {}
    Write-Host "  Done" -ForegroundColor Green

    Write-Host "Step 2/4: Removing old Zoom data..." -ForegroundColor Cyan
    sudo rm -rf /Applications/zoom.us.app
    rm -rf ~/Library/"Application Support"/zoom.us
    rm -rf ~/Library/Logs/zoom.us
    rm -rf ~/Library/Caches/us.zoom.xos
    rm -rf ~/Library/Preferences/us.zoom.xos.plist
    Write-Host "  Done" -ForegroundColor Green

    Write-Host "Step 3/4: Downloading fresh Zoom..." -ForegroundColor Cyan
    mkdir -p ~/Downloads | Out-Null
    curl -sL https://zoom.us/client/latest/Zoom.pkg -o ~/Downloads/Zoom.pkg
    Write-Host "  Done" -ForegroundColor Green

    Write-Host "Step 4/4: Installing Zoom..." -ForegroundColor Cyan
    sudo installer -pkg ~/Downloads/Zoom.pkg -target /
    Write-Host "  Done" -ForegroundColor Green
    Write-Host ""

    $zoomApp = "/Applications/zoom.us.app"

    if (-not (Test-Path $zoomApp)) {
        Write-Host "Installation failed. Please try again." -ForegroundColor Red
        exit 1
    }

    # Handle separate user mode
    if ($SeparateUser) {
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
        Write-Host "  SEPARATE USER MODE (Error 1132 Fix)" -ForegroundColor Cyan
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "This creates a fresh user account with a clean Zoom profile." -ForegroundColor White
        Write-Host "Error 1132 corrupts your Zoom data - a new user bypasses this." -ForegroundColor White
        Write-Host ""
        
        $zoomUser = Read-Host "Enter a username for the new account"
        
        # Check if user exists
        $userCheck = sh -c "id '$zoomUser' 2>/dev/null"
        $userExists = $LASTEXITCODE -eq 0
        
        if (-not $userExists) {
            Write-Host "Creating new user '$zoomUser'..." -ForegroundColor Yellow
            
            # Read password securely
            $password1 = Read-Host "Enter password for new user" -AsSecureString
            $password2 = Read-Host "Confirm password" -AsSecureString
            
            # Convert to plaintext for comparison
            $pass1 = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
                [Runtime.InteropServices.Marshal]::SecureStringToBSTR($password1))
            $pass2 = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
                [Runtime.InteropServices.Marshal]::SecureStringToBSTR($password2))
            
            if ($pass1 -ne $pass2) {
                Write-Host "Passwords do not match. Aborting." -ForegroundColor Red
                exit 1
            }
            
            # Ask about admin privileges
            $makeAdmin = Read-Host "Make user an admin? (y/N)"
            $adminFlag = ""
            if ($makeAdmin -eq 'y' -or $makeAdmin -eq 'Y') {
                $adminFlag = "-admin"
                Write-Host "User will be created with admin privileges." -ForegroundColor Yellow
            }
            
            # Create user with sysadminctl
            try {
                $createCmd = "sudo sysadminctl -addUser '$zoomUser' -password '$pass1' $adminFlag"
                sh -c $createCmd
                
                if ($LASTEXITCODE -ne 0) {
                    throw "sysadminctl failed with exit code $LASTEXITCODE"
                }
                
                Write-Host "User '$zoomUser' created successfully." -ForegroundColor Green
            }
            catch {
                Write-Host "Failed to create user: $_" -ForegroundColor Red
                exit 1
            }
        }
        else {
            Write-Host "User '$zoomUser' already exists. Ready to use!" -ForegroundColor Green
        }
        
        Write-Host ""
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host "  SUCCESS! Next steps:" -ForegroundColor Green
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host ""
        Write-Host "  1. Click Apple menu → Log Out (or use Fast User Switching)" -ForegroundColor White
        Write-Host "  2. Log in as '$zoomUser'" -ForegroundColor White
        Write-Host "  3. Open Zoom and join your meeting" -ForegroundColor White
        Write-Host ""
    }
    else {
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host "  SUCCESS! Zoom has been reset." -ForegroundColor Green
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host ""
        Write-Host "Launching Zoom..." -ForegroundColor Cyan
        open $zoomApp
    }

}
elseif ($IsWindows) {
    Write-Host "Step 1/4: Stopping Zoom..." -ForegroundColor Cyan
    Get-Process -Name "Zoom*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host "  Done" -ForegroundColor Green

    Write-Host "Step 2/4: Removing old Zoom..." -ForegroundColor Cyan
    # Uninstall Zoom (MSI-based)
    try {
        Get-WmiObject -Class Win32_Product -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -like "*Zoom*" } |
            ForEach-Object { $_.Uninstall() | Out-Null }
    } catch {}

    # Remove leftover folders
    @("$env:APPDATA\Zoom", "$env:LOCALAPPDATA\Zoom", "$env:PROGRAMFILES\Zoom", "${env:PROGRAMFILES(X86)}\Zoom") |
        ForEach-Object { if (Test-Path $_) { Remove-Item $_ -Recurse -Force -ErrorAction SilentlyContinue } }
    Write-Host "  Done" -ForegroundColor Green

    Write-Host "Step 3/4: Downloading fresh Zoom..." -ForegroundColor Cyan
    $downloadPath = Join-Path $env:USERPROFILE "Downloads\ZoomInstaller.exe"
    Invoke-WebRequest "https://zoom.us/client/latest/ZoomInstallerFull.exe" -OutFile $downloadPath
    Write-Host "  Done" -ForegroundColor Green

    Write-Host "Step 4/4: Installing Zoom..." -ForegroundColor Cyan
    Start-Process $downloadPath "/silent" -Wait
    Write-Host "  Done" -ForegroundColor Green
    Write-Host ""

    # Find Zoom executable
    $zoomExe = "C:\Program Files\Zoom\bin\Zoom.exe"
    if (-not (Test-Path $zoomExe)) {
        $zoomExe = "C:\Program Files (x86)\Zoom\bin\Zoom.exe"
    }

    if (-not (Test-Path $zoomExe)) {
        Write-Host "Installation failed. Please try again." -ForegroundColor Red
        exit 1
    }

    # Handle separate user mode
    if ($SeparateUser) {
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
        Write-Host "  SEPARATE USER MODE (Error 1132 Fix)" -ForegroundColor Cyan
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "This creates a fresh user account with a clean Zoom profile." -ForegroundColor White
        Write-Host "Error 1132 corrupts your Zoom data - a new user bypasses this." -ForegroundColor White
        Write-Host ""
        
        $zoomUser = Read-Host "Enter a username for the new account"
        
        # Check if user exists
        $userExists = Get-LocalUser -Name $zoomUser -ErrorAction SilentlyContinue
        
        if (-not $userExists) {
            Write-Host "Creating new user '$zoomUser'..." -ForegroundColor Yellow
            $securePass = Read-Host "Enter password for new user" -AsSecureString
            $confirmPass = Read-Host "Confirm password" -AsSecureString
            
            # Convert to plaintext for comparison (necessary evil)
            $pass1 = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
                [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePass))
            $pass2 = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
                [Runtime.InteropServices.Marshal]::SecureStringToBSTR($confirmPass))
            
            if ($pass1 -ne $pass2) {
                Write-Host "Passwords do not match. Aborting." -ForegroundColor Red
                exit 1
            }
            
            try {
                New-LocalUser -Name $zoomUser -Password $securePass -Description "Zoom isolated user" -ErrorAction Stop
                Write-Host "User '$zoomUser' created successfully." -ForegroundColor Green
                
                # Ask about admin privileges
                $makeAdmin = Read-Host "Add user to Administrators group? (y/N)"
                if ($makeAdmin -eq 'y' -or $makeAdmin -eq 'Y') {
                    Add-LocalGroupMember -Group "Administrators" -Member $zoomUser
                    Write-Host "User added to Administrators group." -ForegroundColor Yellow
                }
            }
            catch {
                Write-Host "Failed to create user: $_" -ForegroundColor Red
                exit 1
            }
        }
        else {
            Write-Host "User '$zoomUser' already exists. Ready to use!" -ForegroundColor Green
        }
        
        Write-Host ""
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host "  SUCCESS! Launching Zoom as '$zoomUser'..." -ForegroundColor Green
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host ""
        Write-Host "Enter the password for '$zoomUser' when prompted." -ForegroundColor White
        Write-Host ""
        Start-Process "runas.exe" -ArgumentList "/user:$zoomUser", "`"$zoomExe`""
    }
    else {
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host "  SUCCESS! Zoom has been reset." -ForegroundColor Green
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host ""
        Write-Host "Launching Zoom..." -ForegroundColor Cyan
        Start-Process $zoomExe
    }
}
else {
    Write-Host "Unsupported operating system." -ForegroundColor Red
}

