#!/usr/bin/env bash

TAG=$1

docker build --pull -t redpandaci/ubuntu-dind:$TAG .
