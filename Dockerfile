FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    sudo \
    openssh-server \
    tini \
    && rm -rf /var/lib/apt/lists/*

# Add ansible user
RUN useradd -m -u 71000 -s /bin/bash ansible \
    && echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Setup SSH server
RUN mkdir /var/run/sshd
RUN echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
RUN echo 'AllowUsers ansible' >> /etc/ssh/sshd_config

# Copy SSH keys
COPY ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
COPY ssh/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub
COPY ssh/sshd_config /etc/ssh/sshd_config

# Add the public key for ansible user
RUN mkdir -p /home/ansible/.ssh \
    && chmod 700 /home/ansible/.ssh \
    && touch /home/ansible/.ssh/authorized_keys \
    && chmod 600 /home/ansible/.ssh/authorized_keys \
    && chown -R ansible:ansible /home/ansible/.ssh

COPY ssh/ansible_key.pub /home/ansible/.ssh/authorized_keys

# Set correct permissions for SSH keys
RUN chmod 600 /etc/ssh/ssh_host_rsa_key \
    && chmod 644 /etc/ssh/ssh_host_rsa_key.pub

# Copy init script
COPY init/run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

EXPOSE 22
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/run.sh"]
