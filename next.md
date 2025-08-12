# SOPS Secrets Management Setup Plan

## Overview
Set up SOPS (Secrets OPerationS) for encrypting secrets like API keys and AWS credentials, with most configuration handled through home-manager.

## Setup Steps

### 1. Install Required Packages
Add to appropriate package files:
- System level: `sops` and `age` packages
- Home level: `sops` for user access

### 2. Generate Age Key (One-time setup)
```bash
# Generate age key for encryption
age-keygen -o ~/.config/sops/age/keys.txt
# Note the public key for .sops.yaml config
```

### 3. Create SOPS Configuration
Create `.sops.yaml` in project root:
```yaml
keys:
  - &admin age1xxxxxx # your age public key from step 2
creation_rules:
  - path_regex: home/secrets/.*\.yaml$
    key_groups:
    - age:
      - *admin
```

### 4. Home Manager Integration
Create `home/secrets.nix` module:
- Import sops-nix home-manager module
- Configure sops settings (default file, age key location)
- Define secrets (sample: GitHub API token)

### 5. System-Level SOPS Module
Create minimal `secrets.nix` in root:
- Import sops-nix system module
- Enable sops-nix
- Set age key file location

### 6. Update Workstation Configurations
Add secrets modules to:
- System configuration files (import `./secrets.nix`)
- Home manager configuration (import `./secrets.nix`)

### 7. Create Sample Encrypted Secret
Create `home/secrets/secrets.yaml`:
```yaml
github_token: "ghp_xxxxxxxxxxxx"
```

### 8. Usage Pattern
Secrets will be available as:
- Home manager: `config.sops.secrets.github_token.path`
- System services: `/run/secrets/secret-name`

## File Structure After Setup
```
nixosconfig/
├── .sops.yaml              # SOPS configuration
├── secrets.nix             # System-level SOPS config
├── home/
│   ├── secrets.nix         # Home-manager SOPS config
│   └── secrets/
│       └── secrets.yaml    # Encrypted secrets file
└── configuration-*.nix     # Import secrets modules
```

## Sample Environment Variable Usage
The GitHub token can be used in shell initialization or applications:
```bash
export GITHUB_TOKEN="$(cat ${config.sops.secrets.github_token.path})"
```

## Benefits of This Approach
- Secrets encrypted at rest in git repository
- Decrypted only when needed on target system
- Age key provides strong encryption
- Home manager handles user-level secret management
- Minimal system-level configuration required