#!/bin/bash
# Creates the core from a template, or re-syncs conf/ when the template changes.
# The template must contain conf.sha256 file with hash.
# When the core and template hash files do not match.

set -euo pipefail

TEMPLATE_DIR="/opt/template"
DATA_DIR="/var/solr/data"

# Create a single core.
create_or_update_core() {
  local CORE_NAME=$1
  local TEMPLATE_DIRECTORY=$2
  local CORE_DIRECTORY="$DATA_DIR/$CORE_NAME"
  local HASH_FILE="${CORE_DIRECTORY}/conf.sha256"

  if [ -d "$DATA_DIR/$CORE_NAME" ]; then
    # Get the hash for the core.
    local CORE_HASH_FILE="$CORE_DIRECTORY/core.sha256"
    CORE_HASH="";
    [[ -f "$CORE_HASH_FILE" ]] && CORE_HASH="$(cat "$CORE_HASH_FILE")"
    # Get the hash for the template.
    local TEMPLATE_HASH_FILE="$TEMPLATE_DIRECTORY/core.sha256"
    TEMPLATE_HASH="";
    [[ -f "$TEMPLATE_HASH_FILE" ]] && TEMPLATE_HASH="$(cat "$TEMPLATE_HASH_FILE")"
    #
    if [[ "$CORE_HASH" == "$TEMPLATE_HASH" ]]; then
      echo "[sync-core] Existing '$CORE_NAME' core's config up to date."
    else
      echo "[sync-core] Updating existing '$CORE_NAME' core."
      rm -rf "$CORE_DIRECTORY/conf"
      # As the directory exists we need to copy in a different way.
      cp -r "$TEMPLATE_DIRECTORY" "$DATA_DIR"
    fi
  else
    # Directory does not exists.
    # Based on /opt/solr/docker/scripts/precreate-core
    cp -r "$TEMPLATE_DIRECTORY" "$CORE_DIRECTORY"
    echo "[sync-core] Creating new '$CORE_NAME' core."
  fi
}

# Iterate over templates and create core.
for TEMPLATE_DIRECTORY in "$TEMPLATE_DIR"/*/; do
    # Check if it's actually a directory
    if [ -d "$TEMPLATE_DIRECTORY" ]; then
        #  Get directory name.
        CORE_NAME=$(basename "$TEMPLATE_DIRECTORY")
        create_or_update_core $CORE_NAME $TEMPLATE_DIRECTORY
    fi
done
