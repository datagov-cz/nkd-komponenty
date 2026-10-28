# Build stage: the regular (non-slim) image is required here.
# The "hdt" dependency is a native addon compiled by node-gyp during install.
# It needs Python 3, make and g++, which the slim image does not provide.
FROM node:26.12.1 AS build

WORKDIR /opt/linked-data-fragments

# First install dependencies to keep them in a cache.
# Compiling hdt takes several minutes, so keep this layer separate from the sources.
COPY package*.json ./
RUN npm ci --omit=dev

# Runtime stage: the slim image is enough, as only the compiled modules are needed.
# It must use the same Node.js version and the same base OS as the build stage,
# as the compiled native addon is bound to both.
FROM node:26.12.1-slim

WORKDIR /opt/linked-data-fragments
RUN chown 1000:1000 .

# We do not need to use root.
USER 1000

COPY --from=build --chown=1000:1000 /opt/linked-data-fragments/node_modules ./node_modules

# Now copy all the rest.
COPY --chown=1000:1000 . .

# Run the server.
CMD [ "node", "./server.mjs" ]
