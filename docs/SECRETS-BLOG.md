# Managing API Keys in Development with System Keyrings and direnv

Developers often struggle with API key management during development. Common approaches like hardcoding keys in files, storing them in shell profiles, or manually copying from password managers each have significant drawbacks. This post explores using the existing Linux desktop keyring infrastructure combined with direnv for a more secure and convenient approach.

## The Problem with Current Approaches

Development workflows often involve API keys scattered across various locations:
- `.bashrc` exports (visible in process lists)
- `.env` files (risk of accidental commits)  
- Copy-pasted from password managers (tedious workflow)
- Hardcoded in config files (security risk)

An ideal solution would be secure (encrypted at rest), automatic (no manual copying), per-project (different keys for different projects), and standards-based (portable across Linux environments).

## Using the Desktop Keyring

Modern Linux desktops include secure keyring systems - GNOME Keyring, KWallet, or compatible alternatives. These systems store secrets encrypted on disk, integrate with login authentication, use the standard freedesktop.org Secret Service API, and unlock automatically at login.

Rather than adding another tool, we can leverage this existing infrastructure.

## Building on the Secret Service API

The Secret Service API includes `secret-tool`, a command-line interface for keyring interaction:

```bash
# Store a secret
echo "sk-1234567890abcdef" | secret-tool store --label="OpenAI API" service openai key api

# Retrieve it
secret-tool lookup service openai key api
```

The `service` and `key` attributes enable hierarchical organization. One service can have multiple keys:

```bash
secret-tool store service github key token --label="GitHub Token"
secret-tool store service github key webhook --label="GitHub Webhook Secret"
```

## Developer-Friendly Shell Functions

Raw `secret-tool` commands are verbose, so wrapping them in shell functions improves usability:

```bash
# Simple retrieval
get-secret github token

# Interactive storage with hidden input
store-secret github token "GitHub Personal Access Token"

# List all keys for a service
list-secrets github
```

The `make-env` function generates environment files:

```bash
# Create traditional .env file
make-env github
# Generates: GITHUB_TOKEN=ghp_xxxxxxxxxxxx

# Create direnv-compatible .envrc
make-env --rc github  
# Generates: export GITHUB_TOKEN=$(secret-tool lookup service github key token)
```

## Integration with direnv

[direnv](https://direnv.net/) automatically loads environment variables when entering directories. Combined with keyring integration:

```bash
cd my-project/
make-env --rc openai
direnv allow
```

Now the OpenAI API key loads automatically when entering that directory:

```bash
cd my-project/
# direnv: loading .envrc
# direnv: export +OPENAI_API_KEY

echo $OPENAI_API_KEY  
# sk-1234567890abcdef (fresh from the keyring)
```

Leaving the directory removes the variable, providing project isolation.

## Security Benefits of .envrc

The `.envrc` approach stores commands rather than plaintext secrets:

```bash
# Instead of plaintext:
OPENAI_API_KEY=sk-1234567890abcdef

# Store a command:
export OPENAI_API_KEY=$(secret-tool lookup service openai key api)
```

This provides several benefits:
- No plaintext secrets on disk
- Fresh retrieval each time (supports key rotation)
- Keyring remains encrypted at rest
- Protection against filesystem access

## NixOS Integration

For NixOS users, this integrates cleanly with system configuration:

```nix
# home/shell-secrets.nix
{ config, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;  # Faster environment loading
  };

  programs.bash.bashrcExtra = builtins.readFile ./secrets-functions.sh;
  programs.zsh.initExtra = builtins.readFile ./secrets-functions.sh;
}
```

The functions become available after rebuilding the system configuration.

## Security Model

The security model relies on desktop authentication:

1. **At Login**: Login password automatically unlocks the keyring
2. **During Session**: Secrets accessible via API, encrypted in memory
3. **On Disk**: Secrets remain encrypted, tied to login credentials  
4. **At Logout**: Keyring locks automatically

No separate master password is needed - desktop authentication serves as secret authentication.

## Usage Example

A typical workflow involves:

```bash
# One-time setup: store API keys
store-secret openai api "OpenAI API Key"
store-secret github token "GitHub Token"

# Per-project setup (one time)
cd my-ai-project/
make-env --rc openai
direnv allow

# Daily workflow - automatic loading
cd my-ai-project/
# direnv loads OpenAI key automatically
python train.py  # Uses $OPENAI_API_KEY
```

## Why This Works

This approach succeeds by leveraging existing infrastructure:

- **GNOME Keyring**: Mature, encrypted storage
- **Secret Service API**: Standard protocol, widely supported
- **direnv**: Popular development tool
- **PAM Integration**: Seamless desktop authentication

Rather than creating new tools, it composes existing ones effectively.

## Results

After initial setup, this provides:
- No plaintext API keys in files
- No manual copying from password managers
- Clean shell profiles
- Automatic per-project isolation
- Cross-platform Linux compatibility

The development workflow remains unchanged while secrets become properly secured.

## Implementation

The core concepts work on any Linux system:

1. Use system keyring for secret storage
2. Wrap keyring API in convenient functions
3. Generate direnv-compatible files for automatic loading
4. Rely on login authentication for keyring access

The main insight is leveraging existing desktop infrastructure rather than adding complexity. Often effective solutions involve connecting existing pieces rather than building new ones.