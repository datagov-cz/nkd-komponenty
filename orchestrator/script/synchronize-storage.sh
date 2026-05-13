#!/bin/bash
#
# Rewrite local pipelines and templates in LinkedPipes:ETL from GitHub.
#

set -e

echo "New synchronization run started: $(date)"

echo "Clone pipeline and templates definitions ..."
mkdir -p /tmp/storage/
cd /tmp/storage/
git clone --branch $STORAGE_REPOSITORY_BRANCH $STORAGE_REPOSITORY ./

echo "Move data to storage directory ..."
cp -r ./lp-etl/* /data/lp-etl/storage/

echo "Remove temporary data ..."
rm -rf /tmp/storage/

echo "Reload LinkedPipes ETL ..."
curl -X POST "$STORAGE_URL/api/v1/management/reload"
