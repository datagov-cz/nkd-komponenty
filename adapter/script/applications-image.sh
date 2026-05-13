#!/bin/sh

# Add Java home to path.
export PATH=$JAVA_HOME/bin:$PATH

java -jar /opt/ms-adapter/ms-adapter.jar download-directory \
  --site "$MS_SITE" \
  --path "$MS_APPLICATIONS_PATH" \
  --output /data/applications-images/ \
  >> /data/log/applications-image.log 2>&1
