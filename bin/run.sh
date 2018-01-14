#!/usr/bin/env bash

TAG=$1

docker run \
--privileged \
--rm \
-it \
redpandaci/ubuntu-dind:$TAG
