#!/bin/bash

# Allow to change content using HTTP requests.
# https://solr.apache.org/guide/solr/latest/indexing-guide/content-streams.html#remote-streaming
export SOLR_ENABLE_STREAM_BODY=true
export SOLR_ENABLE_REMOTE_STREAMING=true
