# ubuntu-dind

Ubuntu image with docker in docker strategy (is very important run with --privileged flag)
This docker is based on jpetazzo's and billyteves' dind. Credits to them.

_Supported tags and respective `Dockerfile` links:_
[`1.4.0`, `latest`, `test`](Dockerfile)

## Usage

```bash
docker run --privileged -it -v redpandaci-ubuntu-dind:/var/lib/docker redpandaci/ubuntu-dind:latest
```

## ubuntu version

16.04.6

## Utilities

* docker 19.03.1-ce
* docker-compose 1.24.0
* rancher-compose 0.12.5
* nvm 0.34.8
* node 10.15.3

## Considerations

This project only uses npm to do commit validations and verify Dockerfile coding style.
