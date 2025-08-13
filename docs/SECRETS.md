# Secrets Management System Overview

This document describes the complete secrets management system built for this NixOS configuration. The system integrates GNOME Keyring, custom shell functions, and direnv to provide secure, convenient access to API keys and other secrets during development.

## Architecture Overview

The system consists of three main components:

1. **GNOME Keyring** - Secure encrypted storage using standard Linux desktop APIs
2. **Custom Shell Functions** - Bash/Zsh functions for easy keyring interaction
3. **direnv Integration** - Automatic environment variable loading per project directory

## GNOME Keyring Backend

### What is GNOME Keyring?
GNOME Keyring is the standard secrets storage daemon for Linux desktop environments. It provides encrypted storage of passwords, API keys, and other sensitive data.

### Security Model
- **Encryption**: Secrets stored encrypted on disk at `~/.local/share/keyrings/`
- **Master Key**: Derived from your login password via PAM integration
- **Session-based**: Automatically unlocked at login, locked at logout
- **No idle timeout**: Stays unlocked for entire login session (default behavior)

### Standards Compliance
The system uses the **freedesktop.org Secret Service API**, making it compatible with:
- GNOME Keyring (default)
- KWallet (KDE)
- KeePassXC (with Secret Service integration)
- pass with pass-secret-service

This standards-based approach ensures portability across Linux desktop environments.

### Authentication Integration
- **PAM Integration**: Keyring unlocks automatically using your login password
- **System Integration**: Works with existing fingerprint authentication for sudo
- **No separate passwords**: Your login password is your keyring password

## Custom Shell Functions

### Implementation
The shell functions are implemented in `home/secrets-functions.sh` and embedded into both bash and zsh configurations via `builtins.readFile` during the Nix build process.

### Available Functions

#### `get-secret <service> <key>`
Retrieves a single secret from the keyring.
```bash
get-secret gemini api-key
# Returns: AIzaSyABjIEITGTmHJ50dlkvuozwtqLb9o8PFe4
```

#### `store-secret <service> <key> [label]`
Stores a secret in the keyring with interactive password prompt.
```bash
store-secret gemini api-key "Gemini API Key"
# Prompts for secret value securely
```

#### `list-secrets <service>`
Lists all available keys for a service.
```bash
list-secrets gemini
# Output:
# Secrets for service 'gemini':
#   api-key
#   backup-key
```

#### `make-env [--rc] <service>`
Creates environment files with secrets for a service.

**Standard .env file** (static values):
```bash
make-env gemini
# Creates .env with: GEMINI_API_KEY=AIzaSyABjIEITGTmHJ50dlkvuozwtqLb9o8PFe4
```

**direnv .envrc file** (dynamic shell commands):
```bash
make-env --rc gemini
# Creates .envrc with: export GEMINI_API_KEY=$(secret-tool lookup service gemini key api-key)
```

### Technical Implementation Details

#### stderr/stdout Handling
The `secret-tool search` command outputs:
- **stdout**: Actual secret values
- **stderr**: Metadata including key names

The functions correctly parse stderr for key names while using stdout for secret values.

#### Variable Name Conversion
Keys are automatically converted to environment variable format:
- `api-key` → `API_KEY`
- `backup-token` → `BACKUP_TOKEN`

## Nix Integration

### Package Dependencies
The system requires `libsecret` package, which provides the `secret-tool` command-line interface to the Secret Service API.

### Home Manager Configuration
```nix
# home/shell-secrets.nix
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;  # Enables caching for faster loads
  };

  programs.bash.bashrcExtra = builtins.readFile ./secrets-functions.sh;
  programs.zsh.initExtra = builtins.readFile ./secrets-functions.sh;
}
```

### Build-time Integration
The shell functions are embedded directly into the shell configurations using `builtins.readFile`, eliminating the need for separate script files in the final system.

### Package Installation
The `libsecret` package is added to `home/utils-packages.nix` to ensure `secret-tool` is available.

## direnv Integration

### What is direnv?
direnv automatically loads and unloads environment variables when entering/leaving directories. It's widely used in the Nix ecosystem for project-specific environments.

### nix-direnv Benefits
The system includes `nix-direnv` which provides:
- **Environment Caching**: First build is slow, subsequent loads are instant
- **Garbage Collection Protection**: Prevents Nix from cleaning up dev environments
- **Smart Invalidation**: Only rebuilds when configuration actually changes

### Usage Workflow

#### One-time Setup per Project
```bash
cd my-project/
make-env --rc gemini
direnv allow
```

#### Automatic Loading
```bash
# Every time you cd into the project:
cd my-project/
# direnv: loading ~/my-project/.envrc
# direnv: export +GEMINI_API_KEY

echo $GEMINI_API_KEY
# AIzaSyABjIEITGTmHJ50dlkvuozwtqLb9o8PFe4
```

### .envrc Format
The generated `.envrc` files use direct `secret-tool` calls rather than custom shell functions to avoid dependency issues in direnv's execution context:

```bash
#!/usr/bin/env bash
# direnv envrc for service: gemini
export GEMINI_API_KEY=$(secret-tool lookup service gemini key api-key 2>/dev/null)
```

## Security Considerations

### Threat Model
- **At Rest**: Secrets encrypted on disk, protected by login password
- **In Memory**: Secrets cached in keyring daemon (process isolation)
- **Session Scope**: Keyring unlocked for entire login session
- **File Permissions**: Generated .env files have standard user permissions

### Best Practices
1. **Use .envrc for development**: Dynamic loading, no plaintext secrets on disk
2. **Use .env for production**: Static files when needed, add to .gitignore
3. **Regular key rotation**: Easy to update secrets in keyring
4. **Separate services**: Use different service names for different applications

### Limitations
- **Login password compromise**: Gives access to all stored secrets
- **Session persistence**: Keyring stays unlocked until logout
- **No idle timeout**: Default configuration doesn't lock after inactivity

## Usage Examples

### Storing API Keys
```bash
# Store a new API key
store-secret openai api "OpenAI API Key"
store-secret github token "GitHub Personal Access Token"
```

### Setting up a New Project
```bash
cd my-new-project/
make-env --rc openai
direnv allow
# Now OPENAI_API_KEY is automatically available in this directory
```

### Creating Static Environment Files
```bash
# For deployment or containerization
make-env production > deployment.env
```

### Listing Available Secrets
```bash
list-secrets github
# Secrets for service 'github':
#   token
#   webhook-secret
```

## System Requirements

- NixOS with Home Manager
- GNOME Keyring daemon (included in most desktop configurations)
- libsecret package (provides secret-tool)
- direnv and nix-direnv (for automatic loading)

## Future Enhancements

Potential improvements to consider:
- Idle timeout configuration
- Integration with hardware security keys
- Automated secret rotation
- Team-based secret sharing
- Integration with external secret management systems