FROM nginx:1.29.4

# We need to remove the default server.
RUN rm /etc/nginx/conf.d/default.conf

COPY ./nginx/ /etc/nginx/

EXPOSE 80
