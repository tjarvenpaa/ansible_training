# BASE image - MASTER ja HOST kuvien lähtöpiste

# Käytetään Ubuntu 20.04 LTS kuvaa runkona
FROM ubuntu:20.04

# Asennetaan tarvittavat paketit
RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        aptitude iputils-ping net-tools man vim nano curl openssh-server python3 \
    && rm -rf /var/lib/apt/lists/*

# Varmistetaan että tarvittavat hakemistot luodaan.
RUN mkdir /var/run/sshd
RUN mkdir /root/.ssh
