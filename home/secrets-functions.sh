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
    secret-tool search --all  --unlock service "$service_name" 2>&1 1>/dev/null | while read -r line; do
        if echo "$line" | grep -q "attribute.key = "; then
            key=$(echo "$line" | sed 's/.*attribute.key = //')
            echo "  $key"
        fi
    done
}

# make-env function - create .env file for all secrets of a specific service
make-env() {
    local target_service=""
    local output_file=".env"
    local use_rc_format=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --rc)
                use_rc_format=true
                output_file=".envrc"
                shift
                ;;
            *)
                target_service="$1"
                shift
                ;;
        esac
    done
    
    if [ -z "$target_service" ]; then
        echo "Usage: make-env [--rc] <service-name>" >&2
        echo "Example: make-env gemini" >&2
        echo "Example: make-env --rc gemini  # creates .envrc for direnv" >&2
        return 1
    fi
    
    if [ "$use_rc_format" = true ]; then
        echo "#!/usr/bin/env bash" > "$output_file"
        echo "# direnv envrc for service: $target_service" >> "$output_file"
        echo "# Generated on $(date)" >> "$output_file"
        echo "" >> "$output_file"
    else
        echo "# Secrets for service: $target_service" > "$output_file"
        echo "# Generated on $(date)" >> "$output_file"
        echo "" >> "$output_file"
    fi
    
    local found_secrets=false
    local temp_keys_file=$(mktemp)
    
    # Search for all secrets with matching service - read metadata from stderr
    secret-tool search  --all --unlock service "$target_service" 2>"$temp_keys_file" 1>/dev/null
    
    while read -r line; do
        if echo "$line" | grep -q "attribute.key = "; then
            key=$(echo "$line" | sed 's/.*attribute.key = //')
            # Convert key to uppercase and replace dashes with underscores  
            var_name=$(echo "$key" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
            
            if [ "$use_rc_format" = true ]; then
                # For .envrc, use direct secret-tool call (direnv doesn't have our functions)
                echo "export $var_name=\$(secret-tool lookup service $target_service key $key 2>/dev/null)" >> "$output_file"
                found_secrets=true
            else
                # For .env, get the actual secret value
                secret_value=$(get-secret "$target_service" "$key")
                if [ -n "$secret_value" ]; then
                    echo "$var_name=$secret_value" >> "$output_file"
                    found_secrets=true
                fi
            fi
        fi
    done < "$temp_keys_file"
    
    if [ "$found_secrets" = "true" ]; then
        if [ "$use_rc_format" = true ]; then
            echo "✓ .envrc file created for service '$target_service'"
            echo "  Run 'direnv allow' to enable automatic loading"
        else
            echo "✓ .env file created for service '$target_service'"
        fi
        # Show found keys by reading the temp file
        keys=$(grep 'attribute.key = ' "$temp_keys_file" | sed 's/.*attribute.key = //' | paste -sd, -)
        echo "  Found secrets for keys: $keys"
    else
        echo "✗ No secrets found for service '$target_service'"
        rm -f "$output_file"
    fi
    
    rm -f "$temp_keys_file"
    return $([ "$found_secrets" = "true" ] && echo 0 || echo 1)
}