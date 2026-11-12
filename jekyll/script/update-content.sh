#!/bin/sh
set -e

# Webhook logs only standard output, so errors must go there too.
exec 2>&1

# Allow only one build at a time, others wait for the lock.
exec 9>/data/update-content.lock
flock 9

# Get to the directory and update the content.
cd /data/website/
git fetch --all
git checkout --force origin/$GITHUB_BRANCH

# Build into a new directory, so the served site is never half written.
BUILD_DIR="/data/site/$(date '+%Y%m%d-%H%M%S')-$(git rev-parse --short HEAD)"

# We set RUBYOPT, to deal with
# incompatible character encodings: ASCII-8BIT and UTF-8 (Encoding::CompatibilityError)
export RUBYOPT="-E utf-8:utf-8"
jekyll build --destination "$BUILD_DIR" $JEKYLL_BUILD_CONFIGURATION

# Switch the served site to the new build, rename is atomic.
ln -sfn "$BUILD_DIR" /data/site/current.tmp
mv -T /data/site/current.tmp /data/site/current

# Keep only the current and the previous build.
ls -1d /data/site/2* | sort | head -n -2 | xargs -r rm -rf

# We log the end to be sure we got here.
echo "$(date '+%Y-%m-%d %H:%M:%S') Update complete: $BUILD_DIR"
