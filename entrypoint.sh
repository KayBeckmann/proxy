#!/bin/bash
set -e

HIDDEN_SERVICE_DIR="/var/lib/tor/hidden_service"
TORRC="/etc/tor/torrc"

# Defaults
VANITY_PREFIX="${VANITY_PREFIX:-}"
LOCAL_PORT="${LOCAL_PORT:-80}"
ONION_PORT="${ONION_PORT:-80}"

echo "=== Tor Hidden Service Setup ==="
echo "Local Port: $LOCAL_PORT"
echo "Onion Port: $ONION_PORT"

# Generate vanity address if prefix is set and no keys exist
if [ -n "$VANITY_PREFIX" ] && [ ! -f "$HIDDEN_SERVICE_DIR/hostname" ]; then
    echo "Generating vanity address with prefix: $VANITY_PREFIX"
    echo "This may take a while depending on prefix length..."

    WORK_DIR=$(mktemp -d)
    cd "$WORK_DIR"

    # mkp224o generates v3 onion addresses
    mkp224o -n 1 -d "$WORK_DIR/keys" "$VANITY_PREFIX"

    # Find generated key directory
    KEY_DIR=$(find "$WORK_DIR/keys" -mindepth 1 -maxdepth 1 -type d | head -1)

    if [ -n "$KEY_DIR" ]; then
        mkdir -p "$HIDDEN_SERVICE_DIR"
        cp "$KEY_DIR/hostname" "$HIDDEN_SERVICE_DIR/"
        cp "$KEY_DIR/hs_ed25519_public_key" "$HIDDEN_SERVICE_DIR/"
        cp "$KEY_DIR/hs_ed25519_secret_key" "$HIDDEN_SERVICE_DIR/"
        echo "Vanity address generated: $(cat $HIDDEN_SERVICE_DIR/hostname)"
    else
        echo "ERROR: Failed to generate vanity address"
        exit 1
    fi

    rm -rf "$WORK_DIR"
fi

# Set correct permissions
mkdir -p "$HIDDEN_SERVICE_DIR"
chown -R debian-tor:debian-tor "$HIDDEN_SERVICE_DIR"
chmod 700 "$HIDDEN_SERVICE_DIR"

# Configure torrc
cat > "$TORRC" << EOF
HiddenServiceDir $HIDDEN_SERVICE_DIR
HiddenServicePort $ONION_PORT 127.0.0.1:$LOCAL_PORT
EOF

echo "Starting Tor..."
exec tor -f "$TORRC"
