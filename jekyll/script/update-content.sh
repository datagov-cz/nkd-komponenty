#!/bin/sh

# Get to the directory and update the content.
cd /data/website/
git fetch --all
git checkout --force origin/$GITHUB_BRANCH

# We set RUBYOPT, to deal with
# incompatible character encodings: ASCII-8BIT and UTF-8 (Encoding::CompatibilityError)
export RUBYOPT="-E utf-8:utf-8"
jekyll build

# We log the end to be sure we got here.
echo "$(date '+%Y-%m-%d %H:%M:%S') Update complete"
