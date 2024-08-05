Docker compose + Ansible
The reference implementation of this task was tested with Docker 24.0.6, Docker
Compose 2.21.0 and Ansible version 2.15.2. It can be assumed that these versions
of Docker, Docker Compose and Ansible will be present on the test server during
verification of the assignment. The verification steps will be executed as root.
Feel free to use the same versions of the mentioned tools we used for testing or
any newer version.
The output of the task should be a homework.tar.gz archive which will be
tested as follows:
tar xvzf homework.tar.gz
cd homework
make up
After executing these steps, there should be a Docker Compose stack running
with three services (containers): alpha, bravo and charlie.
These services should be configured as follows:
1. They should all use the Docker image conti-test.
2. If the Docker image is not available yet, it should be built automatically.
3. There should be an init-like daemon running as PID 1 in each container.
4. Each container should have one OpenSSH server running.
5. The contents of the path /opt/data inside charlie should be persisted
on the host.
Requirements for the Docker image conti-test:
1. It should be based on Ubuntu Linux 20.04 LTS (Focal Fossa).
2. There should be a user named ansible with uid 71000 and primary group
ansible (gid 71000) who can sudo to root without the use of a password.
3. If we know the Ansible user’s SSH key, we should be able to SSH into any
container based on the conti-test image as the ansible user with that
SSH key, without the need to provide a password. It should be assumed
that the SSH key is not protected by a passphrase.
Once the containers are running, we should be able to provision them with
Ansible by executing the following command:
make ansible
The Ansible inventory should contain two groups: east (members: alpha, bravo)
and west (members: charlie).
The following things should be provisioned via Ansible:
1. When we SSH into any container in the west group, after login the following
message should be present on the screen: Once upon a time in the
west.

1

2. When we SSH into any container in the east group, after login the following
message should be present on the screen: Eastern promises.
Extra challenges
Complete as many of these as you can.
Extra challenges for the compose stack
1. The names of the Docker containers running the services should be alpha,
bravo and charlie.
2. The hostnames of the service containers should be alpha, bravo and
charlie.
3. All three containers should be on a dedicated Docker network whose name
in Compose should be conti-test. The conti-test network should be a
block of 64 IP addresses starting with 172.16.100.128. The containers
should have the following IP addresses:
• alpha: 172.16.100.140
• bravo: 172.16.100.141
• charlie: 172.16.100.142
4. When executing make up, the containers should come up in the following
order:
1. alpha
2. bravo
3. charlie
5. The sshd process running in charlie should have access to two extra
environment variables: CONTI_ENV and CONTI_DB_NAME. If the user sets
and exports these variables in the shell environment before executing
make up, their values should be visible by the sshd process running inside
charlie.
6. If the CONTI_ENV variable is not set by the user, it should default to prod.
7. If the CONTI_DB_NAME variable is not set by the user, make up should fail
with the following error message: “You must specify CONTI_DB_NAME
in the environment.”
8. If the kernel runs short of memory and decides to unleash the OOM killer,
charlie should have more chance to survive than alpha and bravo.
9. The sshd process running in charlie should be able to open at least
1048576 file descriptors.
10. Bravo should not be able to use more than 10% of a single CPU core.
11. Bravo should not be able to use more than 4 GB of memory.
12. Bravo should not start until the sshd running in alpha does not open its
listening port. Charlie should not start until the sshd running in bravo
does not open its listening port.

2

Extra challenges for Ansible
1. The timezone inside the containers should be set to the value of the
timezone Ansible inventory variable. (note: it’s not a problem if Ansible
throws warnings during the execution of this task due to missing systemd
components if the contents of /etc/timezone reflect the desired change)
2. APT inside the containers should be configured to use only the APT

mirror specified by the apt_mirror Ansible inventory variable and noth-
ing else. An example value for the apt_mirror variable would be

http://ftp.hosteurope.de/mirror/archive.ubuntu.com/ubuntu (one
of the official Ubuntu mirror servers).
