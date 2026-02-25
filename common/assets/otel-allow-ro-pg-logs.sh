#!/bin/bash
set -euo pipefail

set -x

# OTEL_USER to grant access
OTEL_USER="otelcol"

# Get PGDATA
PGDATA=$(sudo -u postgres psql -Atc "SHOW data_directory;" 2>/dev/null)
LOGDIR=$(sudo -u postgres psql -Atc "SHOW log_directory;" 2>/dev/null)
COLLECTOR=$(sudo -u postgres psql -Atc "SHOW logging_collector;" 2>/dev/null)

# Exit gracefully if logging collector is off
if [ "$COLLECTOR" != "on" ]; then
    echo "ERROR: PostgreSQL logging_collector is off" >&2
    exit 1
fi

# Build full path
if [[ "$LOGDIR" = /* ]]; then
    FULL_LOGDIR="$LOGDIR"
else
    FULL_LOGDIR="$PGDATA/$LOGDIR"
fi

# Wait for the log directory to exist (up to 30s)
for _ in {1..30}; do
    [ -d "$FULL_LOGDIR" ] && break
    sleep 1
done

# Error if directory still doesn't exist
if [ ! -d "$FULL_LOGDIR" ]; then
    echo "ERROR: Log directory $FULL_LOGDIR does not exist after 30s" >&2
    exit 1
fi

# Apply ACLs
# Traversal on all parent directories leading to PGDATA
current_path="$PGDATA"
while [ "$current_path" != "/" ]; do
    setfacl -m u:$OTEL_USER:x "$current_path" 2>/dev/null || true
    current_path=$(dirname "$current_path")
done

# Allow read + traverse on logs
setfacl -R -m u:$OTEL_USER:r "$FULL_LOGDIR"
setfacl -m u:$OTEL_USER:rx "$FULL_LOGDIR"
setfacl -d -m u:$OTEL_USER:rx "$FULL_LOGDIR"
