# Keyring-Based Secrets Management Setup Plan

## Overview
Set up a secure keyring for storing secrets like API keys, with fingerprint authentication for access. Focus on security and trustworthiness for Sway desktop environment.

## Keyring Choice: KeePassXC
**Selected for**: Strong security, audit history, no desktop environment dependencies, supports biometric unlock, widely trusted by security community.

Alternative considered: `pass` with `pass-otp` (GPG-based, very secure but less convenient for biometric unlock).

## Setup Steps

### 1. Install Required Packages
Add to appropriate package files:
```nix
# In applications-packages.nix or similar
keepassxc
libfprint  # For fingerprint reader support
fprintd    # Already enabled in your config
```

### 2. Configure Fingerprint Authentication
Ensure fingerprint enrollment:
```bash
# Enroll fingerprint if not already done
sudo fprintd-enroll rafael
```

### 3. Create KeePassXC Database
- Create master database with strong password
- Enable fingerprint unlock in KeePassXC settings
- KeePassXC can use system fingerprint reader for database unlock

### 4. Store Sample Secret
Create entry for GitHub API token:
- Title: "GitHub API Token"
- Username: "rafael" 
- Password: "ghp_xxxxxxxxxxxx"
- Notes: "Personal access token for GitHub API"

### 5. Command Line Access
Install KeePassXC CLI tools:
```nix
# Add to package list
keepassxc-cli
```

### 6. Create Helper Scripts
Create utility scripts in home-manager:

```bash
# ~/.local/bin/get-secret
#!/bin/bash
# Usage: get-secret "GitHub API Token"
keepassxc-cli show ~/secrets.kdbx "$1" -a password
```

```bash
# ~/.local/bin/make-env
#!/bin/bash
# Create .env file from keyring
echo "GITHUB_TOKEN=$(get-secret 'GitHub API Token')" > .env
echo "Secrets loaded to .env"
```

### 7. Integration with Shell
Add to shell configuration:
```bash
# Function to load project secrets
load-secrets() {
    if make-env; then
        echo "✓ Secrets loaded to .env (requires database unlock)"
    else
        echo "✗ Failed to load secrets"
    fi
}
```

## File Structure After Setup
```
nixosconfig/
├── home/
│   ├── keepass-config.nix    # KeePassXC home-manager config
│   └── shell-secrets.nix     # Shell helper functions
└── ~/secrets.kdbx            # KeePassXC database (not in git)
```

## Security Benefits
- Database encrypted with industry-standard algorithms (AES-256)
- Master password + fingerprint two-factor unlock
- No plaintext secrets on disk
- Audit trail of secret access
- Cross-platform, well-audited codebase
- Local-only storage (no cloud sync required)

## Usage Pattern
1. Open project directory
2. Run `load-secrets` (triggers fingerprint prompt)
3. KeePassXC unlocks with fingerprint
4. Secrets written to `.env` file
5. Database locks automatically after timeout

## Alternative: CLI-Only with `pass`
If preferring command-line only:
- Use `pass` (password store) with GPG keys
- Store GPG key in TPM with fingerprint unlock
- More complex but fully CLI-driven