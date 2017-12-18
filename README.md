# Ubuntu-dind

Ubuntu image with docker in docker strategy
This docker is based on jpetazzo's and billyteves' dind. Credits to them.

_Supported tags and respective `Dockerfile` links:_
[`latest`](Dockerfile)

## Usage

```bash
docker run --privileged -v redpandaci-ubuntu-dind:/var/lib/docker redpandaci/ubuntu-dind:latest
```

## Utilities

* docker 17.09.1
* docker-compose 1.17.1
