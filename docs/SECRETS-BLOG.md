# Building a Secure API Key Management System for Development

As developers, we constantly juggle API keys - OpenAI tokens, GitHub access keys, cloud provider credentials. The traditional approaches all have problems: hardcoding them is dangerous, environment variables are scattered across shell profiles, and dedicated password managers interrupt the development flow. Here's how I built a secure, seamless solution using Linux desktop standards and direnv.

## The Problem: API Keys Everywhere

My development workflow was becoming a security nightmare. I had API keys in:
- `.bashrc` exports (visible in process lists)
- Random `.env` files (easy to accidentally commit)  
- Copy-pasted from password managers (tedious and error-prone)
- Hardcoded in config files (we've all done it)

What I needed was a solution that was:
- **Secure**: Keys encrypted at rest, never in plaintext files
- **Automatic**: No manual copying from password managers
- **Per-project**: Different projects need different keys
- **Standards-based**: Work across different Linux environments

## The Key Insight: Your Desktop Already Has a Keyring

Every modern Linux desktop ships with a secure keyring system - GNOME Keyring, KWallet, or compatible alternatives. These systems:

- Store secrets encrypted on disk
- Integrate with your login authentication
- Use the standard freedesktop.org Secret Service API
- Are already unlocked when you log in

The breakthrough was realizing I didn't need another tool - I needed to leverage what was already there.

## Building on the Secret Service API

The Secret Service API provides a command-line tool called `secret-tool` that makes keyring interaction simple:

```bash
# Store a secret
echo "sk-1234567890abcdef" | secret-tool store --label="OpenAI API" service openai key api

# Retrieve it
secret-tool lookup service openai key api
```

The genius is in the `service` and `key` attributes - they let you organize secrets hierarchically. One service can have multiple keys:

```bash
secret-tool store service github key token --label="GitHub Token"
secret-tool store service github key webhook --label="GitHub Webhook Secret"
```

## Wrapping It in Developer-Friendly Functions

Raw `secret-tool` commands are verbose, so I wrapped them in shell functions:

```bash
# Simple retrieval
get-secret github token

# Interactive storage with hidden input
store-secret github token "GitHub Personal Access Token"

# List all keys for a service
list-secrets github
```

The real magic happens with `make-env`, which generates environment files:

```bash
# Create traditional .env file
make-env github
# Generates: GITHUB_TOKEN=ghp_xxxxxxxxxxxx

# Create direnv-compatible .envrc
make-env --rc github  
# Generates: export GITHUB_TOKEN=$(secret-tool lookup service github key token)
```

## The direnv Integration: Automatic Per-Project Secrets

This is where the solution becomes truly elegant. [direnv](https://direnv.net/) automatically loads environment variables when you enter a directory. Combined with our keyring integration:

```bash
cd my-project/
make-env --rc openai
direnv allow
```

Now every time you `cd` into that project directory, your OpenAI API key is automatically available:

```bash
cd my-project/
# direnv: loading .envrc
# direnv: export +OPENAI_API_KEY

echo $OPENAI_API_KEY  
# sk-1234567890abcdef (fresh from the keyring)
```

Leave the directory? The variable disappears. Perfect isolation.

## Why .envrc Instead of .env?

The `.envrc` approach is crucial for security. Instead of storing plaintext secrets:

```bash
# Bad: plaintext secret in file
OPENAI_API_KEY=sk-1234567890abcdef
```

We store a command that fetches the secret dynamically:

```bash  
# Good: command that fetches from encrypted keyring
export OPENAI_API_KEY=$(secret-tool lookup service openai key api)
```

This means:
- No plaintext secrets on disk
- Fresh retrieval each time (supports key rotation)
- Keyring stays encrypted at rest
- Works even if someone gains filesystem access

## The NixOS Integration

Since I use NixOS, I wanted this integrated into my system configuration. The shell functions are embedded directly into my bash/zsh configurations:

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

The functions are available immediately after rebuilding my system configuration. No separate installation or PATH management.

## Security Model in Practice

The security model is elegant in its simplicity:

1. **At Login**: Your login password automatically unlocks the keyring
2. **During Session**: Secrets accessible via API, encrypted in memory
3. **On Disk**: All secrets remain encrypted, tied to your login credentials  
4. **At Logout**: Keyring locks automatically

Since the keyring unlocks with your login password, there's no separate "master password" to remember. Your desktop authentication is your secret authentication.

## Real-World Usage

Here's how it works in practice:

```bash
# One-time setup: store your API keys
store-secret openai api "OpenAI API Key"
store-secret github token "GitHub Token"
store-secret aws secret "AWS Secret Key"

# Per-project setup (one time)
cd my-ai-project/
make-env --rc openai
direnv allow

cd my-web-app/  
make-env --rc github
direnv allow

# Daily workflow - secrets load automatically
cd my-ai-project/
# direnv loads OpenAI key automatically
python train.py  # Uses $OPENAI_API_KEY

cd my-web-app/
# direnv loads GitHub token automatically  
git push  # Uses GitHub token for authentication
```

## Why This Approach Works

This solution succeeds because it leverages existing, battle-tested infrastructure:

- **GNOME Keyring**: Mature, encrypted storage used by millions
- **Secret Service API**: Standard protocol, widely supported
- **direnv**: Popular tool in the development community
- **PAM Integration**: Seamless desktop authentication

Instead of reinventing secret management, we're composing existing tools in a novel way.

## The Result: Invisible Security

The best security is invisible security. After the initial setup:

- API keys are never in plaintext files
- No copying from password managers
- No environment variables cluttering shell profiles
- Per-project isolation happens automatically
- Works across any Linux desktop environment

Your development workflow remains unchanged, but your secrets are properly secured. That's the mark of a good solution - it makes security effortless rather than burdensome.

## Try It Yourself

The complete implementation is available as part of my [NixOS configuration](https://github.com/your-repo), but the core concepts work on any Linux system:

1. Use your system keyring for secret storage
2. Wrap the keyring API in developer-friendly functions
3. Generate direnv-compatible files for automatic loading
4. Let your login authentication unlock everything

The key insight is that your desktop already has the infrastructure - you just need to connect the pieces. Sometimes the best solutions aren't about adding new tools, but using existing ones more thoughtfully.