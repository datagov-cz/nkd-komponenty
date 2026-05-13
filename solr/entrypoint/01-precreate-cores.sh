#!/bin/bash

TEMPLATE_DIR="/opt/template"
TEMPLATE_BASE_DIR="/opt/template-base"
DATA_DIR="/var/solr/data"

for DIR in "$TEMPLATE_DIR"/*/; do
    # Check if it's actually a directory
    if [ -d "$DIR" ]; then
        #  Get directory name.
        NAME=$(basename "$DIR")
        # Check for core existence.
        if [ ! -d "$DATA_DIR/$NAME" ]; then
            # Prepare core data
            cp -nr $TEMPLATE_BASE_DIR/* $DIR
            # Create core.
            precreate-core $NAME $DIR
        fi
    fi
done
