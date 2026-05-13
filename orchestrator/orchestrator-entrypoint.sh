#!/bin/sh

# Initialize volumes.
su nkod /opt/orchestrator/initialize-volumes.sh

# Prepare cron file to be used by the cron.
crontab /etc/cron.d/lp-etl-crontab

# Save current environment variables to be used by cron.
env >> /etc/environment

# Run cron in the foreground.
cron -f
