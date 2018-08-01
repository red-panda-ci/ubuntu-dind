# ubuntu-dind

Ubuntu image with docker in docker strategy (is very important run with --privileged flag)
This docker is based on jpetazzo's and billyteves' dind. Credits to them.

_Supported tags and respective `Dockerfile` links:_
[`1.0.2`, `latest`, `test`](Dockerfile)

## Usage

```bash
docker run --privileged -it -v redpandaci-ubuntu-dind:/var/lib/docker redpandaci/ubuntu-dind:latest
```

## ubuntu version

16.04

## Utilities

* docker 18.03.1-ce
* docker-compose 1.22.0
* rancher-compose 0.12.5
* nvm 0.33.8
* node 8.9.4

## Considerations

This project only uses npm to do commit validations and verify Dockerfile coding style.
