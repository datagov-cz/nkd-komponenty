#!/bin/bash
#
# Initialize public volume.
#

set -e

# allowed-publishers-list.sh
mkdir -p /data/allowed-publishers/  2>/dev/null

# applications-image.sh
mkdir -p /data/applications-images/ 2>/dev/null

# applications-list.sh
mkdir -p /data/applications/ 2>/dev/null

# registrations.sh
mkdir -p /data/registrations/attachments 2>/dev/null
mkdir -p /data/registrations/messages 2>/dev/null

# suggestions-list.sh
mkdir -p /data/suggestions/ 2>/dev/null

# registration manager
mkdir -p /data/registration-manager/attachments 2>/dev/null
mkdir -p /data/registration-manager/messages 2>/dev/null

#
mkdir -p /data/log/ 2>/dev/null
