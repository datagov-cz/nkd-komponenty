#!/bin/sh

# Add Java home to path.
export PATH=$JAVA_HOME/bin:$PATH

java -jar /opt/ms-adapter/ms-adapter.jar download-list \
  --site "$MS_SITE" \
  --list "$MS_ALLOWED_PUBLISHERS_LIST" \
  --base "http://localhost/allowed-publishers" \
  --output /data/allowed-publishers/content.trig  \
  >> /data/log/allowed-publishers-list.log 2>&1
