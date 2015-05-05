FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive

# Tools
RUN apt-get update && \
    apt-get install runit wget -y

# Salt-Stack installation
ENV SALT_VERSION 2014.7.5+ds-1ubuntu1
# add ppa repository
RUN echo deb http://ppa.launchpad.net/saltstack/salt/ubuntu `lsb_release -sc` main | sudo tee /etc/apt/sources.list.d/saltstack.list && \
    wget -q -O- "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x4759FA960E27C0A6" | sudo apt-key add -
RUN sudo apt-get update
# install salt "tools"
RUN apt-get install -y \
    salt-master=$SALT_VERSION

# Configuration
# runit file
ADD files/salt-master.run /etc/sv/salt-master/run
# init files
ADD files/lib/ /opt/container/lib/
RUN mkdir -p /opt/container/services/ && \
    touch /opt/container/services/salt-master.sh
ADD files/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 4505
EXPOSE 4506
CMD ["/init.sh"]