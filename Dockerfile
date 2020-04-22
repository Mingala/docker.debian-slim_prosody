# base version targeted from Docker Hub
ARG BASE_VERSION="10.3-slim"
# Debian base
FROM debian:${BASE_VERSION}
LABEL maintainer="admin@qi2.info"

USER root:root
SHELL ["/bin/bash", "-c"]

# Debian install Sasl and other requirements (Ssl...)
RUN apt update \
  && DEBIAN-FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt install -y --no-install-recommends \
    openssl \
    ca-certificates \
    sasl2-bin \
    libsasl2-2 \
    libsasl2-modules-ldap \
    gnupg dirmngr \
  && rm -rf /var/lib/apt/lists/*

# app version and debian package version targeted
# from Prosody repository
ARG APP_PROSODY_KEY="0x7393d7e674d9dbb5"
ARG APP_PROSODY_REPO="http://packages.prosody.im/debian buster main"
ARG APP_PROSODY_RELEASE="0.11.4-1~buster2"
# from Debian backport repository for Cyrus Sasl
ARG APP_CYRUS_REPO="http://deb.debian.org/debian buster-backports main"
ARG APP_CYRUS_RELEASE="1.1.0-1~bpo10+1"

# Debian repository
#   for Prosody repository as per : https://prosody.im/download/package_repository
#   for Cyrus Sasl
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 ${APP_PROSODY_KEY} \
	&& echo "deb ${APP_PROSODY_REPO}" > /etc/apt/sources.list.d/prosody.list \
	&& echo "deb ${APP_CYRUS_REPO}" > /etc/apt/sources.list.d/cyrussasl.list \
  && apt update \
  && DEBIAN-FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt install -y --no-install-recommends \
    prosody=${APP_PROSODY_RELEASE} \
    lua-cyrussasl=${APP_CYRUS_RELEASE} \
  && rm -rf /var/lib/apt/lists/*

# setup Sasl2 environment for LDAP
COPY ./etc/default/saslauthd /etc/default/saslauthd
# sasl config file (bind mount file at Docker run for custom config) /etc/saslauthd.conf
# add prosody user to sasl group
RUN usermod -a -G sasl prosody

# setup Prosody environment
# port (note that config files port definitions make precedence over this, so if different expose manually correct port)
ENV PROSODY_TCP_PORT="5222 5269 5000"
# config file (bind mount file at Docker run for custom config) /etc/prosody/prosody.cfg.lua
# certificates folder (bind mount folder at Docker run for custom config) /etc/prosody/certs/
# data folder for persistency (bind mount folder at Docker run for custom config) /var/lib/prosody/
# Cyrus sasl config file
COPY ./usr/lib/sasl2/prosody.conf /usr/lib/sasl2/prosody.conf

# entrypoint bash
COPY ./usr/local/bin/docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod u+x /usr/local/bin/docker_entrypoint.sh
EXPOSE ${PROSODY_TCP_PORT}/tcp
ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
