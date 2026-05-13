FROM php:8.3-apache

# Use the default production configuration.
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install packages
RUN apt update && \
  apt install -y --no-install-recommends git ruby-full build-essential wget unzip

# Server configuration
RUN a2enmod rewrite

# Install Ruby and Jekyll.
WORKDIR /opt/jekyll
RUN gem install bundler
COPY ./jekyll/Gemfile ./jekyll/Gemfile.lock ./
RUN bundle install

# Configure apache.
COPY ./apache2/sites-enabled/ /etc/apache2/sites-enabled/
COPY ./apache2/ports.conf /etc/apache2/ports.conf

# Copy API.
COPY --chown=www-data:www-data ./api/ /var/www/api/

# Copy entrypoint.
COPY --chown=www-data:www-data --chmod=0744 ./jekyll-entrypoint.sh /

# Copy other script
WORKDIR /opt/jekyll
COPY --chown=www-data:www-data --chmod=0744 ./script/* ./

WORKDIR /
CMD ["/jekyll-entrypoint.sh"]
