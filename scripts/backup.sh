
#!/usr/bin/env bash
set -Eeuo pipefail

# Override these through environment variables if needed.
SERVER_DIR="${SERVER_DIR:-/home/suor/server-hub}"
BACKUP_DIR="${BACKUP_DIR:-/backups/homelab}"
CONTAINER_NAME="${CONTAINER_NAME:-minecraft_server}"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/homelab-auto-$TIMESTAMP.tar.gz"

MINECRAFT_WAS_RUNNING=0
MINECRAFT_STOPPED_BY_SCRIPT=0

if [[ ! -d "$SERVER_DIR" ]]; then
    echo "ERROR: Project directory does not exist: $SERVER_DIR" >&2
    exit 1
fi

if docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null |
    grep -qx true; then
    MINECRAFT_WAS_RUNNING=1
fi

cleanup() {
    local exit_code=$?
    trap - EXIT

    if [[ "$MINECRAFT_STOPPED_BY_SCRIPT" -eq 1 &&
          "$MINECRAFT_WAS_RUNNING" -eq 1 ]]; then
        echo "[cleanup] Restarting Minecraft..."
        if ! docker start "$CONTAINER_NAME" >/dev/null; then
            echo "WARNING: Minecraft could not be restarted." >&2
            exit_code=1
        fi
    fi

    exit "$exit_code"
}
trap cleanup EXIT

echo "=== Homelab Backup Started: $(date) ==="
mkdir -p "$BACKUP_DIR"

if [[ "$MINECRAFT_WAS_RUNNING" -eq 1 ]]; then
    echo "Stopping Minecraft for a consistent world backup..."
    MINECRAFT_STOPPED_BY_SCRIPT=1
    if ! docker stop "$CONTAINER_NAME"; then
        echo "ERROR: Could not stop Minecraft. Aborting." >&2
        exit 1
    fi
else
    echo "Minecraft was not running; leaving it stopped."
fi

echo "Creating full project and service-data backup..."

if ! tar -czf "$BACKUP_FILE" \
    --exclude='./.git' \
    --exclude='./.env' \
    --exclude='./.env.*' \
    --exclude='*/.env' \
    --exclude='*/.env.*' \
    --exclude='ansible/inventory/hosts.yml' \
    --exclude='*/inventory/hosts.yml' \
    --exclude='./secrets' \
    --exclude='./secrets/*' \
    --exclude='*/secrets' \
    --exclude='*/secrets/*' \
    --exclude='./credentials*' \
    --exclude='*/credentials*' \
    --exclude='./vault-passwords*' \
    --exclude='*/vault-passwords*' \
    --exclude='*.pem' \
    --exclude='*.key' \
    --exclude='*.p12' \
    --exclude='*.pfx' \
    --exclude='*/.ssh' \
    --exclude='*/.ssh/*' \
    --exclude='./monitoring/grafana' \
    --exclude='*/monitoring/grafana' \
    --exclude='./__pycache__' \
    --exclude='*/__pycache__' \
    --exclude='./.venv' \
    --exclude='./venv' \
    --exclude='*/.venv' \
    --exclude='*/venv' \
    --exclude='./minecraft-modpack-staging' \
    --exclude='*/minecraft-modpack-staging' \
    --exclude='*.tmp' \
    --exclude='*/.DS_Store' \
    -C "$SERVER_DIR" .; then
    echo "ERROR: Backup creation failed." >&2
    rm -f "$BACKUP_FILE"
    exit 1
fi

echo "Verifying archive readability..."

if ! tar -tzf "$BACKUP_FILE" >/dev/null; then
    echo "ERROR: Backup verification failed." >&2
    rm -f "$BACKUP_FILE"
    exit 1
fi

echo "Backup completed successfully:"
ls -lh "$BACKUP_FILE"
echo "Archive: $BACKUP_FILE"
echo "=== Homelab Backup Finished: $(date) ==="
