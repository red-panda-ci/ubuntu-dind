# ubuntu-dind

Ubuntu image with docker in docker strategy (is very important run with --privileged flag)
This docker is based on jpetazzo's and billyteves' dind. Credits to them.

_Supported tags and respective `Dockerfile` links:_
[`1.0.0`, `latest`, `test`](Dockerfile)

## Usage

```bash
docker run --privileged -it -v redpandaci-ubuntu-dind:/var/lib/docker redpandaci/ubuntu-dind:latest
```

## ubuntu version

16.04

## Utilities

* docker 17.09.1
* docker-compose 1.17.1
* rancher-compose 0.12.5
* nvm 0.33.8
* node 8.9.4
