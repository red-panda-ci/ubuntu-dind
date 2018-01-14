FROM ubuntu:16.04
LABEL MAINTAINER="Red Panda CI <redpandaci@gmail.com>"

# Let's start with some basic stuff.
ENV DOCKER_VERSION=docker-ce=17.09.1~ce-0~ubuntu
ENV DOCKER_COMPOSE_VERSION=1.17.1
    
RUN apt-get update -y && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common lxc iptables && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update -y && \
    apt-get install -y ${DOCKER_VERSION} && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install redent docker Compose
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install rancher compose
ENV RANCHER_COMPOSE_VERSION 0.12.5
RUN wget https://github.com/rancher/rancher-compose/releases/download/v$RANCHER_COMPOSE_VERSION/rancher-compose-linux-amd64-v$RANCHER_COMPOSE_VERSION.tar.gz && \
    tar zxf rancher-compose-linux-amd64-v$RANCHER_COMPOSE_VERSION.tar.gz && \
    mv rancher-compose-v$RANCHER_COMPOSE_VERSION/rancher-compose /usr/local/bin/rancher-compose && \
    chmod +x /usr/local/bin/rancher-compose && \
    rm rancher-compose-linux-amd64-v$RANCHER_COMPOSE_VERSION.tar.gz && \
    rm -r rancher-compose-v$RANCHER_COMPOSE_VERSION

# nvm and nodejs
ENV NODE_VERSION 8.9.4
ENV NVM_VERSION 0.33.8
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . /root/.nvm/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

# Install the magic wrapper.
COPY ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker
ENTRYPOINT ["wrapdocker"]