FROM ubuntu:noble-20250529

RUN apt-get update \
 && apt-get -y --no-install-recommends install git curl ca-certificates cron

# Create user we use to run the scripts.
ARG USER=5987
RUN addgroup --gid $USER "nkod" \
    && useradd --gid "nkod" --uid $USER "nkod" --create-home

# Copy entrypoint.
COPY ./orchestrator-entrypoint.sh/ /
RUN chown nkod:nkod /orchestrator-entrypoint.sh && chmod 0744 /orchestrator-entrypoint.sh

# Copy other script
WORKDIR /opt/orchestrator
COPY ./script/* ./
RUN chown nkod:nkod *.sh && chmod 0744 *.sh

# Setup cron.
COPY lp-etl-crontab /etc/cron.d/lp-etl-crontab

# Set starting location.
WORKDIR /

# Creating entry point for cron.
CMD ["/orchestrator-entrypoint.sh"]
