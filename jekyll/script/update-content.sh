#!/bin/sh

function join_by { local IFS="$1"; shift; echo "$*"; }

# Collect environment variables for substitution.
vars=$(env | grep JEKYLL_ | awk -F = '{print "$"$1}')
vars=$(join_by ',' $vars)
echo "Found variables $vars"

# Get to the directory and update the content.
cd /data/website/
git fetch --all
git checkout --force origin/$GITHUB_BRANCH

# Process all yaml files and substitute env. variables.
for file in /data/website/*.yml;
do
  echo "Processing $file ...";
  envsubst "$vars" < $file.swp > $file
done

# We set RUBYOPT, to deal with
# incompatible character encodings: ASCII-8BIT and UTF-8 (Encoding::CompatibilityError)
export RUBYOPT="-E utf-8:utf-8"
jekyll build $JEKYLL_BUILD_CONFIGURATION

# We log the end to be sure we got here.
echo "$(date '+%Y-%m-%d %H:%M:%S') Update complete"
