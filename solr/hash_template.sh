#!/bin/bash
# Prepare conf.sha256 files.

set -euo pipefail

TEMPLATE_DIR="/opt/template"
DATA_DIR="/var/solr/data"

# Compute directory hash.
# FIrst hash every file in a directory and then hash the hashes.
hash_dir() {
  ( cd "$1" && find . -type f -print0 | LC_ALL=C sort -z | xargs -0 -r sha256sum ) | sha256sum | cut -d' ' -f1
}

# Iterate over templates and create core.
for TEMPLATE_DIRECTORY in "$TEMPLATE_DIR"/*/; do
    # Check if it's actually a directory
    if [ -d "$TEMPLATE_DIRECTORY" ]; then
        #  Get directory name.
        CORE_NAME=$(basename "$TEMPLATE_DIRECTORY")
        TEMPLATE_HASH_FILE="$TEMPLATE_DIRECTORY/core.sha256"
        #
        hash_dir "$TEMPLATE_DIRECTORY" > $TEMPLATE_HASH_FILE
    fi
done
