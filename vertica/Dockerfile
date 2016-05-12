FROM ubuntu:trusty

# Update the image
RUN apt-get update -y && apt-get upgrade -y

# Install Dependencies
RUN apt-get install -y openssh-server openssh-client mcelog gdb sysstat dialog

# grab gosu for easy step-down from root
RUN apt-get install -y curl \
	&& curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.1/gosu' \
	&& chmod +x /usr/local/bin/gosu

RUN apt-get clean

# Set locale for all system 
RUN locale-gen en_US en_US.UTF-8
RUN dpkg-reconfigure locales 

# Vertica requires bash as default shell
ENV SHELL "/bin/bash"

# Create user dbadmin and configure it
RUN groupadd -r verticadba
RUN useradd -r -m -g verticadba dbadmin
RUN chsh -s /bin/bash dbadmin
RUN chsh -s /bin/bash root
RUN echo "dbadmin -       nice    0" >> /etc/security/limits.conf
RUN echo "dbadmin -       nofile  65536" >> /etc/security/limits.conf

# Install package 
ADD files/vertica_7.2.1-0_amd64.deb /tmp/vertica.deb
ADD files/vertica-console_7.2.2-0_amd64.deb /tmp/vertica-console.deb
RUN dpkg -i /tmp/vertica.deb

# But that's in theory, and for now, this seems sufficient.

# Test DB creation as dbuser
USER dbadmin
RUN mkdir /home/dbadmin/user01db
RUN mkdir /home/dbadmin/user01db/catalog
RUN mkdir /home/dbadmin/user01db/data
 
USER root

RUN echo 'root:root' | chpasswd
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN mkdir /tmp/.python-eggs
RUN chown -R dbadmin /tmp/.python-eggs
ENV PYTHON_EGG_CACHE /tmp/.python-eggs

ENV VERTICADATA /home/dbadmin/user01db

ADD files/docker-entrypoint.sh /home/dbadmin
ADD files/create_user01schema.sql /home/dbadmin
ADD files/vertica-jdbc-7.2.jar /opt/vertica/packages/kafka/lib/vertica-jdbc-7.2.jar

