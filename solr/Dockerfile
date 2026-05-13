# WARN Solr will start in SolrCloud mode by default in version 10,
#   and you will have to provide --user-managed if you want to
#   stay on the user-managed (aka. standalone) mode.
FROM solr:9.8.1

# Copy core definitions and script to create cores.
COPY --chown=solr:solr ./template/ /opt/template/
COPY --chown=solr:solr ./template-base/ /opt/template-base

# Entry point files.
COPY --chown=solr:solr ./entrypoint/ /docker-entrypoint-initdb.d/

# Configuration.
COPY --chown=solr:solr ./log4j2.xml /var/solr/

# Change user.
USER solr

# https://solr.apache.org/guide/solr/latest/configuration-guide/solr-modules.html#installing-a-module
# Enable modules for language specific features.
ENV SOLR_MODULES="analysis-extras"

EXPOSE 8983
