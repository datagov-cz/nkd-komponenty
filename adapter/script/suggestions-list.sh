#!/bin/sh

# Add Java home to path.
export PATH=$JAVA_HOME/bin:$PATH

java -jar /opt/ms-adapter/ms-adapter.jar download-list \
  --site "$MS_SITE" \
  --list "$MS_SUGGESTIONS_LIST" \
  --base "http://localhost/suggestions" \
  --output /data/suggestions/content.trig \
  >> /data/log/suggestions-list.log 2>&1
