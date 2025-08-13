# GNOME Keyring Secrets Management Setup Plan

## Overview
Leverage existing GNOME Keyring setup for storing secrets like API keys, using standard Secret Service API for maximum compatibility.

## Current Status
✅ GNOME Keyring daemon is already running  
✅ Home-manager service enabled in `home/utils-packages.nix`  
❌ Missing `secret-tool` command (`libsecret` package needed)

## Setup Steps

### 1. Add Missing Package
Add `libsecret` to `home/utils-packages.nix`:
```nix
# In home/utils-packages.nix, add to packages list:
libsecret  # Provides secret-tool for Secret Service API access
```

### 2. Test Keyring Access
After rebuild, verify functionality:
```bash
# Store a test secret
secret-tool store --label="Test Secret" service test key sample

# Retrieve it
secret-tool lookup service test key sample
```

### 3. Store Sample API Token
```bash
# Store sample API token
secret-tool store --label="Sample API Token" service myapp key api
# Enter token when prompted: sk_xxxxxxxxxxxx
```

### 4. Create Standards-Based Helper Scripts
Create `home/shell-secrets.nix` for helper functions:

```bash
# get-secret function
get-secret() {
    local service="$1"
    local key="$2"
    secret-tool lookup service "$service" key "$key"
}

# make-env function  
make-env() {
    echo "API_TOKEN=$(get-secret myapp api)" > .env
    echo "✓ Secrets loaded to .env"
}

# load-secrets function
load-secrets() {
    if make-env 2>/dev/null; then
        echo "✓ Secrets loaded successfully"
    else
        echo "✗ Failed to load secrets (keyring locked?)"
        return 1
    fi
}
```

### 5. Configure Fingerprint Unlock
GNOME Keyring automatically integrates with system authentication:
- Uses existing fingerprint setup (fprintd already configured)
- First secret access will prompt for authentication
- Keyring unlocks for entire session after successful auth

### 6. Update Home Manager Configuration
Import the new shell secrets module in appropriate home-manager file.

## File Structure After Setup
```
nixosconfig/
├── home/
│   ├── utils-packages.nix     # Add libsecret here
│   ├── shell-secrets.nix      # Helper functions (new)
│   └── *.nix                  # Import shell-secrets in appropriate file
```

## Security Benefits
- Uses freedesktop.org Secret Service API standard
- Compatible with all major keyrings (GNOME, KWallet, KeePassXC)
- Integrates with system authentication (PAM/fingerprint)
- Encrypted storage in system keyring
- Session-based unlocking (unlock once per login)
- No additional software dependencies

## Usage Pattern
1. Open project directory
2. Run `load-secrets` (may prompt for fingerprint on first access)
3. Secrets written to `.env` file
4. Keyring remains unlocked for session

## Advantages Over KeePassXC Approach
- Already installed and configured
- Uses standard Linux APIs
- No additional GUI applications
- Better integration with system authentication
- Lighter resource usage
- More universal compatibility