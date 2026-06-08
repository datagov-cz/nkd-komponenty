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
    local CORE_HASH_FILE = "$CORE_DIRECTORY/core.sha256"
    CORE_HASH="";
    [[ -f "$CORE_HASH_FILE" ]] && CORE_HASH="$(cat "$CORE_HASH_FILE")"
    # Get the hash for the template.
    local TEMPLATE_HASH_FILE = "$TEMPLATE_DIRECTORY/core.sha256"
    TEMPLATE_HASH="";
    [[ -f "$TEMPLATE_HASH_FILE" ]] && TEMPLATE_HASH="$(cat "$TEMPLATE_HASH_FILE")"
    #
    if [[ "$new_hash" == "$prev_hash" ]]; then
      echo "[sync-core] Existing '$CORE_NAME' core's config up to date."
    else
      echo "[sync-core] Updating existing '$CORE_NAME' core."
      rm -rf "$CORE_DIRECTORY/conf"
      cp -r "$TEMPLATE_DIRECTORY" "$CORE_DIRECTORY"
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

# Subshell so set -e / cd don't leak into the entrypoint shell.
# (
#   CORE="${SOLR_CORE_NAME:-mycore}"
#   TEMPLATE="${SOLR_CORE_TEMPLATE:-/template}"   # your configset dir
#   COREDIR="/var/solr/data/${CORE}"
#   HASHFILE="${COREDIR}/.template.sha256"
#
#   [[ -d "$TEMPLATE" ]] || { echo "[sync-core] template '$TEMPLATE' missing; skip"; exit 0; }
#
#   # Hash = file paths + contents, so add/edit/delete/rename all change it.
#
#   new_hash="$(hash_dir "$TEMPLATE")"
#
#   if [[ ! -d "$COREDIR" ]]; then
#     echo "[sync-core] creating '$CORE' from template"
#     mkdir -p "$COREDIR"
#     cp -a "$TEMPLATE/." "$COREDIR/"
#     mkdir -p "$COREDIR/data"
#     touch "$COREDIR/core.properties"
#     echo "$new_hash" > "$HASHFILE"
#     exit 0
#   fi
#
#   old_hash=""; [[ -f "$HASHFILE" ]] && old_hash="$(cat "$HASHFILE")"
#   if [[ "$new_hash" == "$old_hash" ]]; then
#     echo "[sync-core] '$CORE' config up to date"
#     exit 0
#   fi
#
#   echo "[sync-core] template changed (${old_hash:0:12} -> ${new_hash:0:12}); updating '$CORE'"
#   if command -v rsync >/dev/null 2>&1; then
#     rsync -a --delete \
#       --exclude='/data/' --exclude='/core.properties' --exclude='/.template.sha256' \
#       "$TEMPLATE/" "$COREDIR/"
#   else
#     # No rsync in the base image: replace conf/ wholesale (the usual case).
#     rm -rf "$COREDIR/conf"
#     cp -a "$TEMPLATE/conf" "$COREDIR/conf"
#   fi
#   echo "$new_hash" > "$HASHFILE"
# )