#!/bin/sh

# Make sure mounting point is owned by www-data.
if [ -d "/data/" ]; then
  # This is the expected state.
  :
else
  # The image is running without the mount point.
  mkdir /data/
  chown www-data:www-data /data/
fi

# Download data portal content.
if [ -d "/data/website/" ]; then
  :
else
  mkdir /data/website/
  chown www-data:www-data /data/website/
  su www-data -s /bin/bash -c "cd /data/website/ &&
    git clone https://github.com/$GITHUB_REPOSITORY.git . "
fi

# Jekyll compilation.
# This is our home directory, it must be writable for Jekyll.
chown www-data:www-data /var/www/

# Rebuild repository.
su www-data -s /bin/bash -c '/opt/jekyll/update-content.sh'

# Print debug message.

echo "Watching remote '$GITHUB_REPOSITORY' branch '$GITHUB_BRANCH'."

# Start PHP server.
apache2-foreground
