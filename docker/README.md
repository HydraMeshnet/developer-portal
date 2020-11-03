# Developer Portal Docker

## Build

```bash
$ docker build -f docker/DockerFile -t registry.iop-ventures.com/iop-stack/developer-portal/developer-portal:latest .
$ docker login registry.iop-ventures.com
$ docker push registry.iop-ventures.com/iop-stack/developer-portal/developer-portal
```

## Local Test

```bash
$ docker-compose up
```