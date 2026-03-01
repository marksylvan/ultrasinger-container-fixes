# Patched UltraSinger Container

Ultrasinger with just enough patches to make it usable.

## Installation Instructions

- copy `docker-compose.example.yaml` to `docker-compose.yaml` and modify as required for you.
  - `PUID` and `PGID` should match the user id / group id for the output folder on your host
- run `docker compose up -d`

## Usage Instructions

- open a shell inside the container, either:
  - from anywhere on the host: `docker exec -it ultrasinger /bin/bash`; or
  - from inside this repo directory: `docker compose exec -it /bin/bash`

- run one of the following:
  - download & process: `python3 UltraSinger.py -i 'file' or python3 UltraSinger.py -i 'youtube_url'`
  - process local file: `python3 UltraSinger.py -i 'file' or python3 UltraSinger.py -i '/path/to/file'`
- exit container with CTRL/CMD+D or `exit`
