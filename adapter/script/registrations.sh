#!/bin/sh

# Add Java home to path.
export PATH=$JAVA_HOME/bin:$PATH

java -DconfigurationFile=/opt/isds-adapter/configuration.properties \
  -jar /opt/isds-adapter/isds-adapter.jar >> /data/log/registrations.log 2>&1
