# WARN Solr will start in SolrCloud mode by default in version 10,
#   and you will have to provide --user-managed if you want to
#   stay on the user-managed (aka. standalone) mode.
FROM solr:9.8.1

# Entry point files.
COPY --chown=solr:solr ./entrypoint/ /docker-entrypoint-initdb.d/

# Configuration.
COPY --chown=solr:solr ./log4j2.xml /var/solr/

# Copy core definitions.
COPY --chown=solr:solr ./template/ /opt/template/

# Change user.
USER solr

# Compute template hashes.
COPY --chown=solr:solr --chmod=544 ./hash_template.sh /opt/
RUN /opt/hash_template.sh

# https://solr.apache.org/guide/solr/latest/configuration-guide/solr-modules.html#installing-a-module
# Enable modules for language specific features.
ENV SOLR_MODULES="analysis-extras"

EXPOSE 8983
