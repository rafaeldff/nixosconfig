#!/bin/bash
# Secrets management functions using GNOME Keyring via Secret Service API

# get-secret function - retrieve secret from keyring
get-secret() {
    local service="$1"
    local key="$2"
    
    if [ -z "$service" ] || [ -z "$key" ]; then
        echo "Usage: get-secret <service> <key>" >&2
        return 1
    fi
    
    secret-tool lookup service "$service" key "$key" 2>/dev/null
}

# make-env function - create .env file that shells out to get secrets
make-env() {
    local env_file=".env"
    
    # Create .env file that dynamically retrieves secrets
    cat > "$env_file" << 'EOF'
# Dynamic secrets from GNOME Keyring - no plaintext secrets stored here
API_TOKEN=$(get-secret myapp api 2>/dev/null || echo "")

# Add more secrets as needed
# DB_PASSWORD=$(get-secret database password 2>/dev/null || echo "")
# OPENAI_API_KEY=$(get-secret openai api 2>/dev/null || echo "")
EOF
    
    echo "✓ Dynamic .env file created"
    return 0
}

# load-secrets function - create dynamic .env file
load-secrets() {
    echo "Creating dynamic .env file..."
    
    make-env
    echo "  Use 'source .env' to evaluate and load secrets"
    echo "  Secrets are retrieved from keyring each time .env is sourced"
}

# store-secret function - helper to store secrets
store-secret() {
    local service="$1"
    local key="$2"
    local label="$3"
    
    if [ -z "$service" ] || [ -z "$key" ]; then
        echo "Usage: store-secret <service> <key> [label]" >&2
        echo "Example: store-secret myapp api 'My App API Token'" >&2
        return 1
    fi
    
    if [ -z "$label" ]; then
        label="$service $key"
    fi
    
    echo "Storing secret for service '$service', key '$key'"
    echo "Label: $label"
    echo -n "Enter secret value: "
    read -s secret_value
    echo
    
    if [ -n "$secret_value" ]; then
        echo "$secret_value" | secret-tool store --label="$label" service "$service" key "$key"
        echo "✓ Secret stored successfully"
    else
        echo "✗ Empty secret value, not stored"
        return 1
    fi
}

# list-secrets function - show available secrets for a service  
list-secrets() {
    local service_name="$1"
    
    if [ -z "$service_name" ]; then
        echo "Usage: list-secrets <service-name>" >&2
        echo "Example: list-secrets myapp" >&2
        return 1
    fi
    
    echo "Secrets for service '$service_name':"
    
    # secret-tool search outputs metadata to stderr, secret values to stdout
    # We want the key names from the metadata (stderr)
    secret-tool search --unlock service "$service_name" 2>&1 1>/dev/null | while read -r line; do
        if echo "$line" | grep -q "attribute.key = "; then
            key=$(echo "$line" | sed 's/.*attribute.key = //')
            echo "  $key"
        fi
    done
}

# make-service-env function - create .env file for all secrets of a specific service
make-service-env() {
    local target_service="$1"
    local env_file=".env"
    
    if [ -z "$target_service" ]; then
        echo "Usage: make-service-env <service-name>" >&2
        echo "Example: make-service-env myapp" >&2
        return 1
    fi
    
    echo "# Secrets for service: $target_service" > "$env_file"
    echo "# Generated on $(date)" >> "$env_file"
    echo "" >> "$env_file"
    
    local found_secrets=false
    local temp_keys_file=$(mktemp)
    
    # Search for all secrets with matching service - read metadata from stderr
    secret-tool search --unlock service "$target_service" 2>"$temp_keys_file" 1>/dev/null
    
    while read -r line; do
        if echo "$line" | grep -q "attribute.key = "; then
            key=$(echo "$line" | sed 's/.*attribute.key = //')
            # Convert key to uppercase and replace dashes with underscores  
            var_name=$(echo "$key" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
            
            # Get the actual secret value
            secret_value=$(get-secret "$target_service" "$key")
            if [ -n "$secret_value" ]; then
                echo "$var_name=$secret_value" >> "$env_file"
                found_secrets=true
            fi
        fi
    done < "$temp_keys_file"
    
    if [ "$found_secrets" = "true" ]; then
        echo "✓ .env file created for service '$target_service'"
        # Show found keys by reading the temp file
        keys=$(grep 'attribute.key = ' "$temp_keys_file" | sed 's/.*attribute.key = //' | paste -sd, -)
        echo "  Found secrets for keys: $keys"
    else
        echo "✗ No secrets found for service '$target_service'"
        rm -f "$env_file"
    fi
    
    rm -f "$temp_keys_file"
    return $([ "$found_secrets" = "true" ] && echo 0 || echo 1)
}