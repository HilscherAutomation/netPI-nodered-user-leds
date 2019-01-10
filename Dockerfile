#use latest armv7hf compatible debian OS version from group resin.io as base image
FROM resin/armv7hf-debian:stretch

#enable building ARM container on x86 machinery on the web (comment out next line if built on Raspberry) 
RUN [ "cross-build-start" ]

#labeling
LABEL maintainer="netpi@hilscher.com" \ 
      version="V1.0.0" \
      description="Node-RED with user user leds node to control the user LEDs of netPI"

#version
ENV HILSCHERNETPI_NODERED_USER_LEDS_VERSION 1.0.0

#copy files
COPY "./init.d/*" /etc/init.d/ 
COPY "./node-red-contrib-user-leds/*" /tmp/
#do installation
RUN apt-get update  \
    && apt-get install curl build-essential \
#install node.js
    && curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -  \
    && apt-get install -y nodejs  \
#install Node-RED
    && npm install -g --unsafe-perm node-red \
#install node
    && mkdir /usr/lib/node_modules/node-red-contrib-user-leds \
    && mv /tmp/netiot-io-led.js /tmp/netiot-io-led.html /tmp/package.json -t /usr/lib/node_modules/node-red-contrib-user-leds \
    && cd /usr/lib/node_modules/node-red-contrib-user-leds \
    && npm install \
# generate symbolik links for LEDs
    && mkdir /var/platform \
    && cd /var/platform \
    && ln -s /sys/class/leds/user0:orange:user/brightness led_led2 \
    && ln -s /sys/class/leds/user1:orange:user/brightness led_led1 \
#clean up
    && rm -rf /tmp/* \
    && apt-get remove curl \
    && apt-get -yqq autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

#set the entrypoint
ENTRYPOINT ["/etc/init.d/entrypoint.sh"]

#Node-RED Port
EXPOSE 1880

#set STOPSGINAL
STOPSIGNAL SIGTERM

#stop processing ARM emulation (comment out next line if built on Raspberry)
RUN [ "cross-build-end" ]
