#!/bin/bash
#
# Initialize public volume.
#

set -e

# Make sure all required directories exists.

mkdir -p /data/public/soubor 2>/dev/null

# Prepare files required by LinkedPipes:ETL pipelines.

if [ ! -f /data/public/soubor/nkod.trig ]; then
    touch /data/public/soubor/nkod.trig 2>/dev/null
fi

if [ ! -f /data/public/soubor/nkod-minulý-měsíc.trig ]; then
    touch /data/public/soubor/nkod-minulý-měsíc.trig 2>/dev/null
fi
