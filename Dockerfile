FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y openssh-server sudo netcat && \
    mkdir /var/run/sshd

# Create ansible user with specified UID and GID
RUN groupadd -g 71000 ansible && \
    useradd -m -u 71000 -g ansible ansible && \
    echo "ansible ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Copy the SSH key for the ansible user
COPY id_rsa.pub /home/ansible/.ssh/authorized_keys
RUN chown ansible:ansible /home/ansible/.ssh/authorized_keys && \
    chmod 600 /home/ansible/.ssh/authorized_keys

CMD ["/usr/sbin/sshd", "-D"]
