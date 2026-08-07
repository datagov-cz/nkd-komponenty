ARG NGINX_VERSION=1.30.2
ARG VTS_VERSION=v0.2.6

# ---------------------------------------------------------------------------- #
FROM nginx:${NGINX_VERSION} AS build
ARG NGINX_VERSION
ARG VTS_VERSION

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  ca-certificates \
  git \
  libpcre2-dev \
  libssl-dev \
  zlib1g-dev

# Nginx virtual host traffic status module source.
RUN git clone --depth 1 --branch ${VTS_VERSION} \
    https://github.com/vozlt/nginx-module-vts.git /usr/src/nginx-module-vts

# Nginx source.
RUN curl -fsSL https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    -o /usr/src/nginx.tar.gz \
    && mkdir -p /usr/src/nginx \
    && tar -xzf /usr/src/nginx.tar.gz -C /usr/src/nginx --strip-components=1

WORKDIR /usr/src/nginx

# Build the module.
RUN CONFIG_ARGS=$(nginx -V 2>&1 | sed -n 's/^configure arguments: //p') \
    && eval "./configure ${CONFIG_ARGS} --add-dynamic-module=/usr/src/nginx-module-vts" \
    && make modules

# ---------------------------------------------------------------------------- #
FROM nginx:${NGINX_VERSION}

# Copy the module.
COPY --from=build /usr/src/nginx/objs/ngx_http_vhost_traffic_status_module.so \
    /etc/nginx/modules/ngx_http_vhost_traffic_status_module.so

# We need to remove the default server.
RUN rm /etc/nginx/conf.d/default.conf

COPY ./nginx/ /etc/nginx/

EXPOSE 80
