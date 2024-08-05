FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    sudo \
    openssh-server \
    tini \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 71000 -s /bin/bash ansible \
    && echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir /var/run/sshd
RUN echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
RUN echo 'AllowUsers ansible' >> /etc/ssh/sshd_config

COPY ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
COPY ssh/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub
COPY ssh/sshd_config /etc/ssh/sshd_config

# Set correct permissions for SSH keys
RUN chmod 600 /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key

COPY init/run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

EXPOSE 22
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/run.sh"]
