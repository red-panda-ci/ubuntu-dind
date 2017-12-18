# From Ubuntu LTS
FROM ubuntu:16.04
LABEL MAINTAINER="Red Panda CI <redpandaci@gmail.com>"

# Let's start with some basic stuff.
ENV DOCKER_VERSION=docker-ce=17.09.1~ce-0~ubuntu \
    DOCKER_COMPOSE_VERSION=1.17.1
    
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

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker
ENTRYPOINT ["wrapdocker"]
