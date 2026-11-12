FROM nginx:1.31.8

# Install packages.
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    ruby-full \
    webhook && \
  rm -rf /var/lib/apt/lists/*

# Home directory of www-data, Jekyll and Bundler need it to be writable.
RUN mkdir -p /var/www && chown www-data:www-data /var/www

# Install Jekyll.
WORKDIR /opt/jekyll
RUN gem install bundler
COPY ./jekyll/Gemfile ./jekyll/Gemfile.lock ./
RUN bundle install

# Configure nginx, the template is rendered on start by the nginx entrypoint.
RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx/templates/ /etc/nginx/templates/

# Configure webhook.
COPY ./webhook/hooks.json /etc/webhook/hooks.json

# Copy entrypoint.
COPY --chmod=0755 ./jekyll-entrypoint.sh /

# Copy other scripts.
COPY --chmod=0755 ./script/* /opt/jekyll/

ENV PORT=80

WORKDIR /
CMD ["/jekyll-entrypoint.sh"]
