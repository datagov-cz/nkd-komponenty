FROM couchdb:3.5.0

# https://docs.couchdb.org/en/stable/config/intro.html#configuration-files
COPY ./etc/local.d /opt/couchdb/etc/local.d

# By default the image would use root, which we do not want.
USER couchdb
