#!/usr/bin/env bash

TAG=$1

docker build -t redpandaci/ubuntu-dind:$TAG .