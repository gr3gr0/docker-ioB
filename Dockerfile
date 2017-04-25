FROM debian:latest

MAINTAINER gregro

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y apt-utils curl avahi-daemon git libpcap-dev
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash
RUN apt-get install -y build-essential python nodejs
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime

RUN mkdir -p /opt/iobroker/ && chmod 777 /opt/iobroker/
RUN mkdir -p /opt/scripts/ && chmod 777 /opt/scripts/

WORKDIR /opt/scripts/

ADD scripts/avahi-start.sh avahi-start.sh
RUN chmod +x avahi-start.sh
RUN mkdir /var/run/dbus/

WORKDIR /opt/iobroker/

RUN npm install iobroker --unsafe-perm && echo $(hostname) > .install_host

ADD scripts/startup.sh startup.sh
RUN chmod +x startup.sh

CMD ["sh", "/opt/iobroker/startup.sh"]

ENV DEBIAN_FRONTEND teletype
