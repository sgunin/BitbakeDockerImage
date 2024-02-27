# Bitbake docker file
#    && apt-get install -y libsdl1.2-dev libncurses5-dev flex bison zlib1g-dev gettext g++
#    && apt-get -y install locales apt-utils sudo && dpkg-reconfigure locales && locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
FROM ubuntu:18.04

MAINTAINER Sergey Gunin <sgunin@rambler.ru>

# Layer 1. Install base software
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y locales apt-utils sudo curl u-boot-tools mtd-utils \
    && apt-get install -y gawk wget git diffstat zip unzip texinfo gcc-multilib build-essential chrpath socat cpio \
    && apt-get install -y python python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping \
    && dpkg-reconfigure locales && locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm /bin/sh && ln -s bash /bin/sh \
    && useradd -U -d /build -G sudo -m -s /bin/bash build \
    && curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo && chmod a+x /usr/local/bin/repo

ENV LANG en_US.UTF-8                                                                 
ENV LC_ALL en_US.UTF-8
USER build
WORKDIR /build

# Layer 2. Download and config BSP release
RUN repo init -u https://github.com/sgunin/somlabs-bsp.git -b warrior \
    && repo sync \
    && source ./setup-environment build \
    && bitbake console-extraimage-debug                                 