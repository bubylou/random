# random

Website that displays a random video loaded from a directory. Mostly used as a dev playground.

## Environment-Variables

| Variable  | Description                          | Default Values  | Allowed Values |
|-----------|--------------------------------------|-----------------|----------------|
| RV_DIR    | Directory containing video files.    | /data/videos    | directory      |
| RV_PORT   | Port to bind application to.         | 3000            | 1024-65535     |

## Examples

### Docker Run

```bash
docker run --name random \
    -p 3000:3000 \
    -v ./videos:/data/videos \
    --restart unless-stopped \
    ghcr.io/bubylou/random:latest
```

### Docker Compose

```yml
services:
  moria:
    container_name: random
    image: ghcr.io/bubylou/random:latest
    restart: unless-stopped
    environment:
      - RV_DIR=/data/videos
      - RV_PORT=3000
    ports:
      - 3000:3000
    volumes:
      - ./videos:/data/videos
```

## Building

```shell
docker buildx bake
```
