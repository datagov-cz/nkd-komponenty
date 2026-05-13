FROM node:22

WORKDIR /opt/linked-data-fragments
RUN chown 1000:1000 .

# We do not need to use root.
USER 1000

# First install dependencies to keep them in a cache
COPY --chown=1000:1000 package*.json ./
RUN npm ci --only=production

# Now copy all the rest.
COPY --chown=1000:1000 . .

# Run the server.
CMD [ "node", "./server.mjs" ]
