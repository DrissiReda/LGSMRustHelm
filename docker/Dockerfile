FROM ubuntu:20.04

LABEL maintainer="LinuxGSM <me@danielgibbs.co.uk>"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM=xterm
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install UTF-8 unicode
RUN echo "**** Install UTF-8 ****" \
    && apt-get update \
    && apt-get install -y locales apt-utils debconf-utils
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

## Upgrade Ubuntu
RUN echo "**** apt upgrade ****" \
    && apt-get update; \
    apt-get upgrade -y

## Install Base LinuxGSM Requirements
RUN echo "**** Install Base LinuxGSM Requirements ****" \
    && apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository multiverse \
    && apt-get update \
    && apt-get install -y \
    bc \
    binutils \
    bsdmainutils \
    bzip2 \
    ca-certificates \
	cron \
    cpio \
    curl \
    distro-info \
    file \
    gzip \
    hostname \
    jq \
    lib32gcc1 \
    lib32stdc++6 \
    netcat \
    python3 \
    tar \
    tmux \
    unzip \
    util-linux \
    wget \
    xz-utils \
    # Docker Extras
    cron \
    iproute2 \
    iputils-ping \
    nano \
    vim \
    sudo \
    lib32z1 \
    tini

# Install SteamCMD
RUN echo "**** Install SteamCMD ****" \
    && echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections \
    && dpkg --add-architecture i386 \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends libsdl2-2.0-0:i386 steamcmd \
    && ln -s /usr/games/steamcmd /usr/bin/steamcmd

# Install NodeJS
RUN echo "**** Install NodeJS ****" \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get update && apt-get install -y nodejs

# Install GameDig https://docs.linuxgsm.com/requirements/gamedig
RUN echo "**** Install GameDig ****" \
    && npm install -g gamedig

# Install Cleanup
RUN echo "**** Cleanup ****"  \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

##Need use xterm for LinuxGSM##

ENV DEBIAN_FRONTEND noninteractive
ARG USERNAME=linuxgsm
ARG USER_UID=1001
ARG USER_GID=$USER_UID

## Add linuxgsm user
RUN echo "**** Add linuxgsm user ****" \
# Create the user
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME
WORKDIR /linuxgsm

## Download linuxgsm.sh
RUN echo "**** Download linuxgsm.sh ****" \
    && set -ex \
    && wget -O linuxgsm.sh https://linuxgsm.sh \
    && chmod +x linuxgsm.sh

# install rust
RUN ./linuxgsm.sh rustserver

COPY entrypoint.sh /

EXPOSE 30015 30016 30082

ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]

