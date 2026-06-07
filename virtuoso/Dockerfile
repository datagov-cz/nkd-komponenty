FROM openlink/virtuoso-opensource-7:7.2.16

# Copy init scripts.
COPY --chmod=544 --chown=virtuoso:virtuoso ./initdb.d/ /initdb.d/

# Update ownership of /database directory.
RUN chown virtuoso:virtuoso /database

# By default the image would use root, which we do not want.
USER virtuoso
