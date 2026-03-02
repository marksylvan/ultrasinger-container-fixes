# Patched UltraSinger Container

[UltraSinger](https://github.com/rakuri255/UltraSinger) with just enough patches to make it usable.

## Installation Instructions - Docker Compose

- copy `docker-compose.example.yaml` to `docker-compose.yaml` and modify as required for you.
  - `PUID` and `PGID` should match the user id / group id for the output folder on your host

## Usage Instructions

### Ephemeral Container

| Action                       | `docker compose` command                                        | `docker` command                                                                                                                              |
| ---------------------------- | --------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| Help                         | `docker compose run --rm ultrasinger -h`                        | `docker run --rm --name ultrasinger -v ./output:/app/UltraSinger/src/output -e PGID=1000 -e PUID=1000 ultrasinger -h`                        |
| Process a file               | `docker compose run --rm ultrasinger -i "${url}"`               | `docker run --rm --name ultrasinger -v ./output:/app/UltraSinger/src/output -e PGID=1000 -e PUID=1000 ultrasinger -i "${url}"`               |
| Process a file with language | `docker compose run --rm ultrasinger -i "${url}" --language en` | `docker run --rm --name ultrasinger -v ./output:/app/UltraSinger/src/output -e PGID=1000 -e PUID=1000 ultrasinger -i "${url}" --language en` |
| Shell as appuser             | `docker compose run --rm -it ultrasinger shell`                 | `docker run --rm -it --name ultrasinger --user 1000:1000 -v ./output:/app/UltraSinger/src/output ultrasinger shell`                          |
| Root shell                   | `docker compose run --rm -it ultrasinger root`                  | `docker run --rm -it --name ultrasinger -v ./output:/app/UltraSinger/src/output ultrasinger root`                                            |

Note: with ephemeral containers there's no "start" row - each command creates and destroys its own container. The `docker compose run` commands are much cleaner since volumes, env vars, and image name are all in the compose file.

### Persistent Container

| Action                       | `docker compose` command                                                                 | `docker` command                                                                                                    |
| ---------------------------- | ---------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| Start container              | `docker compose up`                                                                      | `docker run --rm --name ultrasinger -v ./output:/app/UltraSinger/src/output -e PGID=1000 -e PUID=1000 ultrasinger` |
| Help                         | `docker compose exec ultrasinger /usr/local/bin/entrypoint.sh -h`                        | `docker exec ultrasinger /usr/local/bin/entrypoint.sh -h`                                                           |
| Process a file               | `docker compose exec ultrasinger /usr/local/bin/entrypoint.sh -i "${url}"`               | `docker exec ultrasinger /usr/local/bin/entrypoint.sh -i "${url}"`                                                  |
| Process a file with language | `docker compose exec ultrasinger /usr/local/bin/entrypoint.sh -i "${url}" --language en` | `docker exec ultrasinger /usr/local/bin/entrypoint.sh -i "${url}" --language en`                                    |
| Shell as appuser             | `docker compose exec -it --user 1000:1000 ultrasinger /bin/bash`                         | `docker exec -it --user 1000:1000 ultrasinger /bin/bash`                                                            |
| Root shell                   | `docker compose exec -it ultrasinger /bin/bash`                                          | `docker exec -it ultrasinger /bin/bash`                                                                             |

Note: the docker compose up equivalent handles the volume and env vars via docker-compose.yml rather than inline flags, so those are defined in the compose file rather than the command.
