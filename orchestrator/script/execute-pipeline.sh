#!/bin/bash
#
# Create a new execution of pipeline with given URL.
#

set -e

echo "Creating an execution for pipeline '$@' ..."
curl -X POST "$FRONTEND_URL/api/v1/executions?pipeline=$@"
