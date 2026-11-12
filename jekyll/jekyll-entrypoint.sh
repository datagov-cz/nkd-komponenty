#!/bin/sh

# Content is created and built as www-data.
if [ ! -d "/data/" ]; then
  # The image is running without the mount point.
  mkdir /data/
  chown www-data:www-data /data/
fi

if [ ! -d "/data/site/" ]; then
  mkdir /data/site/
  chown www-data:www-data /data/site/
fi

# Download data portal content.
if [ ! -d "/data/website/" ]; then
  mkdir /data/website/
  chown www-data:www-data /data/website/
  su www-data -s /bin/sh -c "cd /data/website/ &&
    git clone https://github.com/$GITHUB_REPOSITORY.git . "
fi

# Build the website.
if ! su www-data -s /bin/sh -c '/opt/jekyll/update-content.sh'; then
  echo "Initial build failed, serving the previous build if any."
fi

# Start webhook listener for GitHub push events.
echo "Watching remote '$GITHUB_REPOSITORY' branch '$GITHUB_BRANCH'."
su www-data -s /bin/sh -c 'webhook -hooks /etc/webhook/hooks.json -template -ip 127.0.0.1 -port 9000 -verbose' &

# Start nginx using the image entrypoint, it renders the configuration templates.
exec /docker-entrypoint.sh nginx -g 'daemon off;'
