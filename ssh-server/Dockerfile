FROM ubuntu:25.10

# Update package list and install OpenSSH server
RUN apt-get update && \
  apt-get install -y openssh-server

# Allow password authentication
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
  sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Copy entrypoint
WORKDIR /opt/openssh-server
COPY ./entrypoint.sh ./
RUN chmod u+x ./entrypoint.sh

# Expose the SSH port
EXPOSE 22

# Start the SSH service
CMD ["/opt/openssh-server/entrypoint.sh"]
